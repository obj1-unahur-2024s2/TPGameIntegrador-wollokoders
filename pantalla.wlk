import juego.*

class Cifra {
    var image = "0.png"
    const position

    method image() = image
    method position() = position

    method mostrar(numero) {
        image = numero.toString() + ".png"
    }

    method enCero() = image == "0.png"
}

class PantallaDeNumeros {
    //cuando creas un objeto te va a pedir estos 2 valores de posición x,
    //por ejemplo podrían ser 1500 y 1700 para que se muestre en la derecha
    const xDecena
    const xUnidad

    const decena = new Cifra(position=game.at(xDecena, 50))
    const unidad = new Cifra(position=game.at(xUnidad, 50))

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
        var tiempo = segundos

        game.onTick(1000, "temporizador", {
            self.mostrar(tiempo)
            tiempo -= 1

            if(cifras.all({c => c.enCero()}))
                game.removeTickEvent("temporizador")
                juego.terminarPartida()
                /*
                el último método aun no está creado. pero removería figuritas y cursor,
                y agregaría una imagen de "partida terminada" que aun no hicimos :(
                */
        })
    }
}