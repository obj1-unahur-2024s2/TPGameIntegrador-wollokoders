import otros.*
import cursor.*
import tarjeta.*

object juego {
	var tarjetasActuales = []
	var cursor = null
	const sonidoDeFondo = game.sound("copatheme.mp3")
	

	method tarjetasActuales() = tarjetasActuales

	method configurar() {
		game.cellSize(1)
		game.width(1920)
		game.height(1200)
		game.boardGround("main.jpg")
		game.addVisual(config)
		game.addVisual(instrucciones)
		sonidoDeFondo.shouldLoop(true)
		sonidoDeFondo.play()
		keyboard.s().onPressDo({sonidoDeFondo.pause()})
		keyboard.r().onPressDo({sonidoDeFondo.resume()})
		

		keyboard.e().onPressDo({
			game.addVisual(fondoVacio)
			self.iniciar()
			self.crearCursor()
		})
		keyboard.t().onPressDo({
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
		tarjetasActuales = if (config.tablero() == 1) self.generar12Tarjetas() else self.generar18Tarjetas()

		tarjetasActuales.forEach({t => game.addVisual(t) })

        //sirve para testear pantalla ganaste. borrar para la versión final
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

	method asociarTarjetasAFrente(tarjetas, indicesFinales) {
		tarjetas.size().times({ i =>
			tarjetas.get(i-1).frente(config.tablero().toString() + "ARG" + indicesFinales.get(i-1) + ".jpg")
		})	

		return tarjetas
	}

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
				winTheme.play()
            }
        })		
}

method volverAlMenu() {
    // Eliminar visuales de la partida (tarjetas, cursor, etc.)
    game.removeVisual(fondoVacio)
    game.removeVisual(cursor)
	game.removeVisual(tutorial)
	 
    tarjetasActuales.forEach({ t =>
        game.removeVisual(t) // Elimina cada tarjeta individualmente
    })
    
   	game.addVisual(config)
	game.addVisual(instrucciones)
	
}
}