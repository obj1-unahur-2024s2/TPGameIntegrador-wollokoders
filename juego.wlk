import interfaz.*
import numeros.*
import otros.*
import cursor.*
import tarjeta.*
import sonidos.*

object juego {
	var tarjetasActuales = []
	var puntos = 0

	method tarjetasActuales() = tarjetasActuales
	method puntos() = puntos

	method configurar() {
		interfaz.configurar()
		interfaz.mostrarMenu()
	}

	method iniciar() {
		puntos = 0
		tarjetasActuales = if (config.tablero() == 1) self.generar12Tarjetas() else self.generar18Tarjetas()

		interfaz.desplegarTarjetas()
		interfaz.crearCursor()
		interfaz.mostrarPuntosYTiempo()

        //sirve para testear pantalla ganaste
        keyboard.enter().onPressDo({
			tarjetasActuales.forEach({t => t.descubrir() })
            self.comprobarPartidaGanada()
        })
	}

	method generar12Tarjetas() {
		const tarjetas = []
		const x = -262 //50 - 312

		6.times({i =>
				tarjetas.add(new Tarjeta(position = game.at(x+312*i, 780)))
				tarjetas.add(new Tarjeta(position = game.at(x+312*i, 380)))
		})

		const sufijos = self.elegirSufijosRandom(6)
		return self.asociarTarjetasAFrente(tarjetas, sufijos)
	}

	method generar18Tarjetas() {
		const tarjetas = []
		const x = -272 // 50 - 322

		6.times({i =>
				tarjetas.add(new Tarjeta(position = game.at(x+322*i, 870)))
				tarjetas.add(new Tarjeta(position = game.at(x+322*i, 560)))
				tarjetas.add(new Tarjeta(position = game.at(x+322*i, 250)))
		})

		const sufijos = self.elegirSufijosRandom(9)
		return self.asociarTarjetasAFrente(tarjetas, sufijos)
	}

	method elegirSufijosRandom(cantUnicos) {
		//desde una lista de 1 a 20, selecciona al azar los números únicos
		//para usarlos como sufijos del nombre del archivo del frente de la tarjeta
		const posiblesSufijos = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
		const sufijosFinales = []

		cantUnicos.times({ i =>
			const valor = posiblesSufijos.anyOne()
			sufijosFinales.add(valor)
			posiblesSufijos.remove(valor)
		})

		//a la lista de números random únicos, le vuelvo a ingresar los
		//números que ya tiene pero en diferente orden. esto permitirá
		//que haya pares de tarjetas y que el orden sea impredecible
		const listaCopia = sufijosFinales.copy()

		cantUnicos.times({ i => 
			const valor = listaCopia.anyOne()
			sufijosFinales.add(valor)
			listaCopia.remove(valor)
		})

		return sufijosFinales
	}

	method asociarTarjetasAFrente(tarjetas, sufijosFinales) {
		const pais = self.elegirUnPais()

		tarjetas.size().times({ i =>
			tarjetas.get(i-1).frente(config.tablero().toString() + pais + sufijosFinales.get(i-1) + ".jpg")
		})	

		return tarjetas
	}

	method elegirUnPais() = if (config.seleccion() == 3) "ARG" else ["BRA", "PAR", "URU", "BOL", "CAN"].anyOne()

    method comprobarPar(par) {
        const a = par.first()
        const b = par.last()

        if(a.frente() != b.frente()) {
			a.ocultar()
			b.ocultar()
			sonidos.incorrecto().play()
        }
		else {
			sonidos.correcto().play()
			self.calcularPuntaje()
			interfaz.actualizarPuntaje()
	        self.comprobarPartidaGanada()
		}
    }

	method calcularPuntaje() {
		puntos = puntos + self.puntosPorTablero() + self.puntosPorSeleccion()
	}

	method puntosPorTablero() = if (config.tablero() == 1) 0 else 1

	method puntosPorSeleccion() = if (config.seleccion() == 3) 1 else 3

	method calcularBonus() {
		const porc = interfaz.tiempo().porcentajeRestante()

		return //porc / 2
			if(porc > 50) 25
			else if(porc > 40) 20
			else if(porc > 30) 15
			else if(porc > 20) 10
			else if(porc > 10) 5
			else 0
			// if(porc % 10 == 0 and porc < 60) porc / 2
			// else -1
	}

    method comprobarPartidaGanada() {
        game.schedule(500, {
            if(tarjetasActuales.all({t => t.estaDescubierta()}))
				interfaz.ganar()
		})		
	}
}