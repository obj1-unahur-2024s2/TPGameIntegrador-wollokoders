import cursor.*
class Tarjeta {
	const position
	var image = "dorso.jpg"
	var frente = ""
	// const property id = null

	method image() = image
    method frente() = frente
	method position() = position

    method estaDescubierta() = image != "dorso.jpg"

	method frente(imagenFrente) {
		frente = imagenFrente
	}

	method descubrir() {
		if (not self.estaDescubierta()) image = frente
	}

	method ocultar() {
		game.schedule(1000	, {image = "dorso.jpg"})
	}
}