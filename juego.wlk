import otros.*
import cursor.*
import tarjeta.*

object juego {
	var tarjetasActuales = []
	var dificultad = 1 //falta implementar dificultad 2

	method tarjetasActuales() = tarjetasActuales

	method configurar() {
		game.cellSize(1)
		game.width(1920)
		game.height(1200)
		game.boardGround("maind.jpg")
		game.addVisual(config)
		game.addVisual(instrucciones)

		keyboard.e().onPressDo({
			game.addVisual(fondoVacio)
			self.iniciarEnDificultad(dificultad)
			game.addVisual(cursor)
		})
	}

	method iniciarEnDificultad(numero) {
		if(dificultad == numero) {
			tarjetasActuales = self.generarTarjetas()
			tarjetasActuales.forEach({t => game.addVisual(t) })
		}

        //testear pantalla ganaste. borrar para la versión final
        keyboard.enter().onPressDo({
			tarjetasActuales.forEach({t => t.descubrir() })
            self.comprobarPartidaGanada()
        })  
	}

    //ver si se puede reducir complejidad. probablemente sea
    //refactorizada para la dificultad 2
	method generarTarjetas() {
		const tarjetas = []

		//crea 12 tarjetas y las guarda en la lista que se retornará
		const x = -262
		6.times({i =>
				tarjetas.add(new Tarjeta(position = game.at(x+312*i, 780)))
				tarjetas.add(new Tarjeta(position = game.at(x+312*i, 380)))
		})

		//desde una lista de 1 a 20, selecciona al azar 6 números para
		//usarlos como nombre del archivo del frente de la tarjeta
		const posiblesIndices = []
		const indicesFinales = []

		20.times({ i => 
				posiblesIndices.add(i)
		})

		6.times({ i =>
				const valor = posiblesIndices.anyOne()
				indicesFinales.add(valor)
				posiblesIndices.remove(valor)
		})

		//a la lista de 6 números random, le vuelvo a ingresar los
		//números que ya tiene pero en diferente orden. esto permitirá
		//que haya pares de tarjetas
		const listaCopia = indicesFinales.copy()

		6.times({ i => 
				const valor = listaCopia.anyOne()
				indicesFinales.add(valor)
				listaCopia.remove(valor)
		})

        //asocio cada tarjeta a un archivo para el frente
		12.times({ i =>
				tarjetas.get(i-1).frente("ARG" + indicesFinales.get(i-1) + ".png")
		})

		return tarjetas
	}

    method comprobarPar(par) {
        //tuve problemas si usaba foreach dentro de schedule, por eso
        //use las constantes

        const a = par.first()
        const b = par.last()

        if(a.frente() != b.frente()) {
            // game.schedule(1000, {
            //     a.ocultar()
            //     b.ocultar()
            // })
			a.ocultar()
			b.ocultar()
        }

        self.comprobarPartidaGanada()
    }

    method comprobarPartidaGanada() {
        game.schedule(500, {
            if(tarjetasActuales.all({t => t.estaDescubierta()})) {
                tarjetasActuales.forEach({t => game.removeVisual(t)})
                game.removeVisual(cursor)
				game.removeVisual(fondoVacio)
                game.addVisual(ganaste)
            }
        })
    }
}