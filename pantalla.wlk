import interfaz.*
import otros.*
import juego.*

class Cifra {
    var image = "numx.png"
    const position

    method image() = image
    method position() = position

    method mostrar(numero) {
        image = "num" + numero.toString() + ".png"
    }

    method enCero() = image == "num0.png"
}

class PantallaDeNumeros {
    //cuando creas un objeto te va a pedir estos 2 valores de posición x,
    //por ejemplo podrían ser 1500 y 1700 para que se muestre en la derecha
    const xDecena
    const xUnidad
    const y

    const decena = new Cifra(position=game.at(xDecena, y))
    const unidad = new Cifra(position=game.at(xUnidad, y))

    const cifras = [decena, unidad]

    method initialize() {
        cifras.forEach({c => game.addVisual(c)})
    }

    method replegar() {
        cifras.forEach({c => game.removeVisual(c)})
    }

    method mostrar(numero) {
        decena.mostrar((numero / 10).truncate(0))
        unidad.mostrar(numero % 10)
    }

    method temporizador(segundos) {
        self.mostrar(segundos)
        var tiempo = segundos - 1

        game.onTick(1000, "temporizador", {
            self.mostrar(tiempo)
            tiempo -= 1

            if(cifras.all({c => c.enCero()})) {
                game.removeTickEvent("temporizador")
                interfaz.tiempoTerminado()
            }
        })
    }
}