class Naves{
    var velocidad
    var direccionRespectoSol
    const property cantidadPasajeros
    var combustible

    method initialize() {
        if(!direccionRespectoSol.between(-10, 10)){
            self.error("la cantidad iniciada no respeta la condicion")
        }
    }

    method velocidad() = velocidad
    method direccionRespectoSol() = direccionRespectoSol

    method acelerar(cuanto) { velocidad = (velocidad + cuanto).min(100000)}
    method desacelerar(cuanto) { velocidad = (velocidad - cuanto).max(0)}

    method irHaciaElSol() { direccionRespectoSol = 10}
    method escaparDelSol() { direccionRespectoSol = -10}
    method ponerseParaleloAlSol() { direccionRespectoSol = 0}

    method acercarseUnPocoAlSol() { direccionRespectoSol = (direccionRespectoSol + 1).min(10)}
    method alejarseUnPocoDelSol() { direccionRespectoSol = (direccionRespectoSol - 1).max(-10)}

    method prepararViaje() {
        self.cargarCombustible(30000)
        self.acelerar(5000)
    }

    method combustible() = combustible
    method cargarCombustible(cantidad) { combustible = combustible + cantidad}
    method descargarCombustible(cantidad) { combustible = combustible - cantidad}

    method tranquilo() = combustible >= 4000 && velocidad <= 120000

    method recibirAmenaza(){
        self.escapar()
        self.avisar()
    }

    method escapar()
    method avisar()

    method estaRelajado() = self.tranquilo() 

}

// TIPOS DE NAVE

class NaveBaliza inherits Naves {
    var property colorBaliza
    var property cambioBaliza = false

    method cambiarColorDeBaliza(colorNuevo) { 
        cambioBaliza = true
        colorBaliza = colorNuevo}

    override method prepararViaje() {
        super()
        colorBaliza = "verde"
        cambioBaliza = true
        self.ponerseParaleloAlSol()
    }

    method colorDistintoA(unColor) = colorBaliza != unColor
    override method tranquilo() = super() && self.colorDistintoA("rojo")

    override method escapar() { self.irHaciaElSol()}

    override method avisar() { self.cambiarColorDeBaliza("rojo")}

    override method estaRelajado() = super() && !self.cambioBaliza()
}

class NavePasajeros inherits Naves {
    var property comida = 0
    var property bebida = 0

    method cargarComida(cantidad) { comida = comida + cantidad}
    method descargarComida(cantidad) { comida = comida - cantidad}

    method cargarBebida(cantidad) { bebida = bebida + cantidad}
    method descargarBebida(cantidad) { bebida = bebida - cantidad}

    override method prepararViaje() {
        super()
        self.cargarComida(4 * cantidadPasajeros)
        self.cargarBebida(6 * cantidadPasajeros)
        self.acercarseUnPocoAlSol()
    }

    override method escapar() { self.acelerar(velocidad * 2)}
    override method avisar() {
        self.descargarComida(cantidadPasajeros)
        self.descargarBebida(cantidadPasajeros * 2)
    }

    override method estaRelajado() = super() && comida < 50
}

class NaveCombate inherits Naves {
    var visible = false
    var misilesDesplegados = false
    const property mensajes = []

    method ponerseVisible() { visible = true}
    method ponerseInvisible() { visible = false}
    method estaInvisible() = visible

    method desplegarMisiles() { misilesDesplegados = true}
    method replegarMisiles() { misilesDesplegados = false}
    method misilesDesplegados() = misilesDesplegados

    method emitirMensaje(unMensaje) { mensajes.add(unMensaje)}
    method mensajesEmitidos() = mensajes
    method primerMensajeEmitido() = mensajes.first()
    method ultimoMensajeEmitido() = mensajes.last()
    method cantLetrasPorPalabra() = mensajes.map({m=>m.length()})
    method esEscueta() = self.cantidadPasajeros().any({ m=> m < 30})
    method emitioMensaje(unMensaje) = mensajes.contains(unMensaje)

    override method prepararViaje() {
        super()
        self.replegarMisiles()
        self.acelerar(15000)
        self.emitirMensaje("Saliendo en mision")

    }

    override method tranquilo() = super() && !self.misilesDesplegados()

    override method escapar() {
        self.acercarseUnPocoAlSol()
        self.acercarseUnPocoAlSol()
    }
    override method avisar() {
        self.emitirMensaje("Amenaza Recibida")
    }

}

// NUEVAS VARIANTES DE NAVE

class NaveHospital inherits NavePasajeros {
    var property quirofanoPreparado
    override method tranquilo() = super() && !self.quirofanoPreparado()

    override method recibirAmenaza() {
        super()
        quirofanoPreparado = true
    }
}

class NaveCombateSigiloso inherits NaveCombate {
    override method tranquilo() = super() && !self.estaInvisible()

    override method escapar() {
        super()
        self.desplegarMisiles()
        self.ponerseInvisible()
    }
}