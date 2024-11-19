import pantalla.*
import otros.*
import cursor.*
import tarjeta.*
import sonidos.*

object juego {
	var tarjetasActuales = []
	var cursor = null
	const sonidoDeFondo = game.sound("copatheme.mp3")
	var tiempo = null
	var puntaje = null
	var puntos = 0

	method tarjetasActuales() = tarjetasActuales

	method configurar() {
		game.cellSize(1)
		game.width(1920)
		game.height(1200)
		game.boardGround("mainb.jpg")
		game.addVisual(config)

		instrucciones.iniciarTitileo()
		sonidoDeFondo.shouldLoop(true)
		sonidoDeFondo.play()
		sonidoDeFondo.volume(0.5)

		self.configurarTeclas()		
	}

	method configurarTeclas() {
		keyboard.s().onPressDo({sonidoDeFondo.pause()})
		keyboard.r().onPressDo({sonidoDeFondo.resume()})

		keyboard.e().onPressDo({
			instrucciones.detenerTitileo()
			game.addVisual(fondoVacio)
			self.iniciar()
			
			self.crearCursor()
		})
		keyboard.t().onPressDo({
			self.retirarVisuales()
			game.addVisual(tutorial)
		})
		keyboard.m().onPressDo({
			self.volverAlMenu()
		})
	}

	method crearCursor() {
		/*
						|  x12  |  x18
		yFilaArriba		|  780	|  870
		yFilaAbajo		|  380	|  250
		xColIzquierda	|  50	|  50
		xColDerecha		|  1610	|  1660
		variacionEnX	|  312	|  322
		variacionEnY	|  400	|  310
		cantFilas		|  2	|  3
		*/

		if(config.tablero() == 1)
			cursor = new Cursor(yFilaArriba=780, yFilaAbajo=380, xColDerecha=1610, variacionEnX=312, variacionEnY=400, cantFilas=2)
		else 
			cursor = new Cursor(yFilaArriba=870, yFilaAbajo=250, xColDerecha=1660, variacionEnX=322, variacionEnY=310, cantFilas=3)
		
		game.addVisual(cursor)
	}

	method iniciar() {
		puntos = 0

		tarjetasActuales = if (config.tablero() == 1) self.generar12Tarjetas() else self.generar18Tarjetas()

		tarjetasActuales.forEach({t => game.addVisual(t) })

		game.addVisual(textoTiempo)
		tiempo = new PantallaDeNumeros(xDecena=1620, xUnidad=1650, y=80)
		tiempo.temporizador(if (config.tablero() == 1) 50 else 99)

		textoPuntos.position(game.at(184,98))
		game.addVisual(textoPuntos)
		puntaje = new PantallaDeNumeros(xDecena=430, xUnidad=460, y=80)
		puntaje.mostrar(0)

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
			incorrecto.play()
        }
		else {
			correcto.play()
			self.calcularPuntaje()
			puntaje.mostrar(puntos)
		}
        self.comprobarPartidaGanada()
    }

	method calcularPuntaje() {
		puntos = puntos + self.puntosPorTablero() + self.puntosPorSeleccion()
	}

	method puntosPorTablero() = if (config.tablero() == 1) 1 else 2

	method puntosPorSeleccion() = if (config.seleccion() == 3) 1 else 3

    method comprobarPartidaGanada() {
        game.schedule(500, {
            if(tarjetasActuales.all({t => t.estaDescubierta()})) {
				self.retirarVisuales()
				game.removeTickEvent("temporizador")
                game.addVisual(ganaste)
				winTheme.play()
				self.volverAMostrarPuntos()
            }
		})		
	}

	method volverAMostrarPuntos() {
		textoPuntos.position(game.at(786,300))

		game.addVisual(textoPuntos)
		puntaje = new PantallaDeNumeros(xDecena=1030, xUnidad=1060, y=282)
		puntaje.mostrar(puntos)
	}

	method tiempoTerminado() {
			derrota.play()
			self.retirarVisuales()
			game.addVisual(tiempoTerminado)
			self.volverAMostrarPuntos()
	}

	method volverAlMenu() {
		game.clear()
		// self.retirarVisuales()
		game.removeTickEvent("temporizador")
		game.addVisual(config)
		config.initialize()
		instrucciones.iniciarTitileo()
		self.configurarTeclas()
	}

	method retirarVisuales() {
		game.allVisuals().forEach({ v => game.removeVisual(v)})
		instrucciones.detenerTitileo()
	}
}