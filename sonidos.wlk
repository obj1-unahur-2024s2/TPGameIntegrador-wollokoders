class Sonido {
    const path

    method play() {
        game.sound(path).play()
    }
}

class SonidoLoop inherits Sonido {
    const sound = game.sound(path)

    override method play() {
        sound.shouldLoop(true)
        sound.volume(0.5)
        game.schedule(500, { sound.play() })
    }

    method resume() {
        if(sound.paused()) sound.resume()
    }

    method pause() {
        if(not sound.paused()) sound.pause()
    }
}

object sonidos {
    const derecha = new Sonido(path="desplazar-derecha.mp3")
    const izquierda = new Sonido(path="desplazar-izquierda.mp3")
    const arriba = new Sonido(path="desplazar-arriba.mp3")
    const abajo = new Sonido(path="desplazar-abajo.mp3")

    const correcto = new Sonido(path="correcto.mp3")
    const incorrecto = new Sonido(path="incorrecto.mp3")
    const clic = new Sonido(path="clic.mp3")
    const ganar = new Sonido(path="win.mp3")
    const fondo = new SonidoLoop(path="copatheme.mp3")

    method derecha() = derecha
    method izquierda() = izquierda
    method arriba() = arriba
    method abajo() = abajo
    method correcto() = correcto
    method incorrecto() = incorrecto
    method clic() = clic
    method ganar() = ganar
    method fondo() = fondo
}