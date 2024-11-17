import juego.*
import game.*

object cursor {
	//defino valores de los extremos para usar como validadadores
	//para no pasarme cuando me muevo. No son constantes porque van
	//a cambiar cuando agreguemos la dificultad 2
	var yFilaArriba = 780
	var yFilaAbajo = 380
	var xColIzquierda = 50
	var xColDerecha = 1610

    var ultimoParDeTarjetas = []

	var position = game.at(50,780)
	var ubicacion = 1

	method position() = position
	method image() = "cursor.png"

	method modificarPosicion(x, y, u)  {
		position = game.at(position.x() + x, position.y() + y)
		ubicacion += u
	}

	method initialize() {
		keyboard.left().onPressDo({ 
			if (position.x() != xColIzquierda) self.modificarPosicion(-312, 0, -2)
		})

		keyboard.right().onPressDo({
			if (position.x() != xColDerecha) self.modificarPosicion(312, 0, 2)
		})

		keyboard.down().onPressDo({
			if (position.y() != yFilaAbajo) self.modificarPosicion(0, -400, 1)
		})

		keyboard.up().onPressDo({
			if (position.y() != yFilaArriba) self.modificarPosicion(0, 400, -1)
		})

		keyboard.space().onPressDo({
            const tarjetaSeleccionada = juego.tarjetasActuales().get(ubicacion - 1)

            if(not tarjetaSeleccionada.estaDescubierta()) {
                tarjetaSeleccionada.descubrir()
                ultimoParDeTarjetas.add(tarjetaSeleccionada)
				self.verificarPar()
            }
		})
	}

	method verificarPar() {
		if(ultimoParDeTarjetas.size() == 2) {
			juego.comprobarPar(ultimoParDeTarjetas)
			ultimoParDeTarjetas.clear()
		}
	}
}