import juego.*
import otros.*
import game.*

class Cursor {
	const yFilaArriba
	const yFilaAbajo
	const xColIzquierda = 50
	const xColDerecha
	const variacionEnX
	const variacionEnY
	const cantFilas

	const ultimoParDeTarjetas = []

	var position = game.at(xColIzquierda,yFilaArriba)
	var ubicacion = 1

	method position() = position
	method image() = "cursor" + config.tablero() + ".png"

	method modificarPosicion(x, y, u)  {
		position = game.at(position.x() + x, position.y() + y)
		ubicacion += u
	}

	method initialize() {
		keyboard.left().onPressDo({ 
			if (position.x() != xColIzquierda) self.modificarPosicion(-variacionEnX, 0, -cantFilas)
			desplazamientoIzquierda.play()
		})

		keyboard.right().onPressDo({
			if (position.x() != xColDerecha) self.modificarPosicion(variacionEnX, 0, cantFilas)
			desplazamientoDerecha.play()
		})

		keyboard.down().onPressDo({
			if (position.y() != yFilaAbajo) self.modificarPosicion(0, -variacionEnY, 1)
			desplazamientoAbajo.play()
		})

		keyboard.up().onPressDo({
			if (position.y() != yFilaArriba) self.modificarPosicion(0, variacionEnY, -1)
			desplazamientoArriba.play()
		})

		keyboard.space().onPressDo({
			darVuelta.play()
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