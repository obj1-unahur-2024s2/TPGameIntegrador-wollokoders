object fondoVacio {
	method position() = game.origin()

	method image() = "vaciob.jpg"
}

object tutorial {
    method position() = game.origin()

    method image() = "reglas.jpg"
  
}

object ganaste {
    method position() = game.origin()

    method image() = "win3.jpg"
}

object config {
    var tablero = 1 //1 o 2
    var seleccion = 3 //3 o 4
    var image = "config13c.png"

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
        image = "config" + tablero.toString() + seleccion.toString() + "c.png"
    }
}

object instrucciones {
    method image() = "instrucciones.png"

    method position() = game.at(0, 50)
}

//Efectos de sonido
object desplazamientoDerecha {
    method play() {
        game.sound("desplazar-derecha.mp3").play()
    }
}

object desplazamientoIzquierda {
    method play() {
        game.sound("desplazar-izquierda.mp3").play()
    }
}

object desplazamientoArriba {
    method play() {
        game.sound("desplazar-arriba.mp3").play()
    }
}

object desplazamientoAbajo {
    method play() {
        game.sound("desplazar-abajo.mp3").play()
    }
}

object darVuelta {
    method play() {
        game.sound("dar-vuelta.mp3").play()
    }
  
}

object correcto {
    method play() {
        game.sound("correcto.mp3").play()
    }
}

object incorrecto {
    method play() {
        game.sound("incorrecto.mp3").play()
    }
}

object winTheme {
    method play() {
        game.sound("win.mp3").play()
    }
}

//falta el sonido de fondo