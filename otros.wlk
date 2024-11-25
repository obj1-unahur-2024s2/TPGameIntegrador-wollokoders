object fondoTablero {
	method position() = game.origin()

	method image() = "vacio1.jpg"
}

object tutorial {
    method position() = game.origin()

    method image() = "tutorialycontroles.jpg"
}



object ganaste {
    method position() = game.origin()

    method image() = "win4.jpg"
}

object tiempoTerminado {
    method position() = game.origin()

    method image() = "tiempoTerminadob.jpg"
}

object config {
    var tablero = 1 //1 o 2
    var seleccion = 3 //3 o 4
    var image = "config13d.png"

    method tablero() = tablero
    method seleccion() = seleccion
    method image() = image
    method position() = game.at((1920 - 914) / 2, 300)

    method initialize() {
		keyboard.num1().onPressDo({
            tablero = 1
            self.cambiarImagen()
		})
        keyboard.num2().onPressDo({
            tablero = 2
            self.cambiarImagen()
		})
        keyboard.num3().onPressDo({
            seleccion = 3
            self.cambiarImagen()
		})
        keyboard.num4().onPressDo({
            seleccion = 4
            self.cambiarImagen()
		})
    }

    method cambiarImagen() {
        image = "config" + tablero.toString() + seleccion.toString() + "d.png"
    }
}

object instrucciones {
    var visibilidad = true

    method image() = "instrucciones.png"
    
    method position() = game.at(0, 50)
    
    method iniciarTitileo() {
        game.onTick(800, "titileo", {
            visibilidad = not visibilidad
            if (visibilidad) {
                game.addVisual(self)  
            } else {
                game.removeVisual(self)  
            }
        })
    }

    method detenerTitileo() {
        game.removeTickEvent("titileo")
        game.removeVisual(self)  
    }
}

object textoPuntos {
    var property position = game.at(184, 128)
    
    method image() = "Puntosb.png"
}

object textoBonus {
    method position() = game.at(184, 68)

    method image() = "Bonus.png"
}

object textoTiempo {
    method image() = "Tiempob.png"

    method position() = game.at(1430, 98)
}