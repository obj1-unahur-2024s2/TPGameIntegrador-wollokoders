object fondoVacio {
	method position() = game.origin()

	method image() = "vaciob.jpg"
}

object ganaste {
    method position() = game.origin()

    method image() = "win5.jpg"
}

object config {
    var tablero = 1 //1 o 2
    var seleccion = 3 //3 o 4

    var image = "config13c.png"
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