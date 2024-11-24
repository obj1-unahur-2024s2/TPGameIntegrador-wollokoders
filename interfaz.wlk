import sonidos.*
import otros.*
import juego.*
import cursor.*
import pantalla.*

object interfaz {
	var puntaje = null

    method configurar() {
        game.cellSize(1)
		game.width(1920)
		game.height(1200)
		game.boardGround("mainb.jpg")
		sonidos.fondo().play()
    }

    method mostrarMenu() {
        game.addVisual(config)
		instrucciones.iniciarTitileo()
		self.configurarTeclas()
    }

    method configurarTeclas() {
		keyboard.s().onPressDo({
			sonidos.fondo().pause()
		})
		
		keyboard.r().onPressDo({
			sonidos.fondo().resume()
		})

		keyboard.e().onPressDo({
			instrucciones.detenerTitileo()
			game.addVisual(fondoVacio)
			juego.iniciar()
		})

		keyboard.t().onPressDo({
			self.retirarVisuales()
			game.addVisual(tutorial)
		})

		keyboard.m().onPressDo({
			self.volverAlMenu()
		})
	}

    method desplegarTarjetas() {
        juego.tarjetasActuales().forEach({ t => game.addVisual(t)})
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
        game.addVisual(
            if(config.tablero() == 1)
                new Cursor(yFilaArriba=780, yFilaAbajo=380, xColDerecha=1610, variacionEnX=312, variacionEnY=400, cantFilas=2)
            else
                new Cursor(yFilaArriba=870, yFilaAbajo=250, xColDerecha=1660, variacionEnX=322, variacionEnY=310, cantFilas=3)
        )
	}

    method mostrarPuntosYTiempo() {
        game.addVisual(textoTiempo)
		const tiempo = new PantallaDeNumeros(xDecena=1620, xUnidad=1650, y=80)
		tiempo.temporizador(if (config.tablero() == 1) 50 else 99)

		textoPuntos.position(game.at(184,98))
		game.addVisual(textoPuntos)
		puntaje = new PantallaDeNumeros(xDecena=425, xUnidad=455, y=80)
		puntaje.mostrar(0)
    }

    method actualizarPuntaje() {
        puntaje.mostrar(juego.puntos())
    }

    method volverAMostrarPuntos() {
		textoPuntos.position(game.at(786,300))

		game.addVisual(textoPuntos)
		puntaje = new PantallaDeNumeros(xDecena=1030, xUnidad=1060, y=282)
		self.actualizarPuntaje()
	}

    method volverAlMenu() {
		game.clear()
		game.removeTickEvent("temporizador")
		config.initialize()
        self.mostrarMenu()
	}

    //pantallas ganar y tiempo terminado
    method retirarVisuales() {
		game.allVisuals().forEach({ v => game.removeVisual(v)})
		instrucciones.detenerTitileo()
	}

    method ganar() {
        self.retirarVisuales()
        game.removeTickEvent("temporizador")
        game.addVisual(ganaste)
        sonidos.ganar().play()
        self.volverAMostrarPuntos()
    }

	method tiempoTerminado() {
        self.retirarVisuales()
        game.addVisual(tiempoTerminado)
        self.volverAMostrarPuntos()
	}
}