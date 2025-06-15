
class Nave {
  var property velocidad
  var property direccionSol
  var property cantidadPasajeros
  var property combustible

  method initialize() {
    if(direccionSol > 10 || direccionSol < -10){
      throw new Exception(message = "tu direccion al sol es mayor 10 o meno que -10")
    }
  }


  method acelerar(cuanto) { velocidad = (velocidad + cuanto).min(100000)}
  method desacelerar(cuanto) { velocidad = (velocidad - cuanto).min(0)}
  method irHaciaElSol() { direccionSol = 10}
  method escaparDelSol() { direccionSol = -10}
  method ponerseParaleloAlSol() { direccionSol = 0}
  method acercarseUnPocoAlSol() { direccionSol = (direccionSol + 1).max(10)}
  method alejarseUnPocoDelSol() { direccionSol = (direccionSol -1).min(-10)}
  method preparaViaje() {
    self.cargarCombustible(30000)
    self.acelerar(5000)
  }
  method combustible()
  method cargarCombustible(cantidad) { combustible = combustible + cantidad}
  method descargarCombustible(cantidad) { combustible = combustible - cantidad}
  method estaTranquila() = combustible >= 4000 && velocidad <= 12000
  method recibirAmenaza() {self.escapar() && self.avisar()} 
  method escapar()
  method avisar()
  method relajo() = self.estaTranquila()
}

class Navebaliza inherits Nave {
  var baliza
  var cambioDeBaliza = false
  method baliza() = baliza

  method initialize(){
    const validos = #{"rojo", "verde", "azul"}
    if(!validos.contains(baliza)){
      throw new Exception(message = "el color de la valiza debe ser un strig con alguno de los valores: rojo, verde o azul")
    }
  }


  method cambiarBaliza(unaBaliza) { 
    const coloresValidos = #{"verde", "rojo", "azul"}
    if(!coloresValidos.contains(unaBaliza)){
      throw new Exception(message = "el color de la valiza debe ser un strig con alguno de los valores: rojo, verde o azul")
    }
    else {
      baliza = unaBaliza
      cambioDeBaliza = true
    }
  }
  
  
    override method preparaViaje() {
      super()
      self.cambiarBaliza("verde")
      self.ponerseParaleloAlSol()
    }

    override method estaTranquila() = super() && baliza != "rojo"

    override method escapar() {self.irHaciaElSol()}
    override method avisar() { self.cambiarBaliza("rojo")}
    override method relajo() = super() && !cambioDeBaliza

}

class NavesPasajeros inherits Nave {
  var property comidas
  var property bebidas 
  method cargarComidas(cantidad) { comidas = comidas + cantidad}
  method descargarComidas(cantidad) { comidas = comidas - cantidad}
  method cargarBebidas(unaBebida) { bebidas = bebidas + unaBebida}
  method descargarBebidas(unaBebida) { bebidas = bebidas - unaBebida }
  override method preparaViaje() {
    self.cargarComidas(4 * cantidadPasajeros)
    self.cargarBebidas(6 * cantidadPasajeros)
    self.acercarseUnPocoAlSol()
    super()
  }
  override method escapar() {velocidad = velocidad * 2}
  override method avisar(){
    self.descargarComidas(cantidadPasajeros)
    self.descargarBebidas(cantidadPasajeros * 2)
  }
  override method relajo() = super() && comidas < 50
}

class NaveDeCombate inherits Nave {
  var visibilidad = false
  var desplegadoMisiles = false
  const mensajesEmitidos = []

  method ponerseVisible() { visibilidad = true}
  method ponerseInvisible() { visibilidad = false}
  method estaInvisible() = visibilidad

  method desplegarMisiles()  { desplegadoMisiles = true}
  method replegarMisiles() { desplegadoMisiles = false}
  method misilesDesplegados()= desplegadoMisiles


  method emitirMensaje(mensaje) { mensajesEmitidos.add(mensaje)}
  method mensajesEmitidos() = mensajesEmitidos
  method primerMensajeEmitido() = mensajesEmitidos.first()
  method ultimoMensajeEmitido() = mensajesEmitidos.last()

  method esEscueta() = mensajesEmitidos.all({m=> m.length() >= 30})

  method emitioMensaje(mensaje) = mensajesEmitidos.contains(mensaje)

  override method preparaViaje() {
    self.ponerseInvisible()
    self.replegarMisiles()
    self.acelerar(15000)
    self.emitioMensaje("Saliendo en Mision")
    super()
  }

  override method estaTranquila() = super() && !desplegadoMisiles

  override method escapar() {
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
  }
  override method avisar() {
    self.emitirMensaje("Amenaza Recibida")
  }
}

class NaveHospital inherits NavesPasajeros {
  var quirofanosPreparados
  method quirofanosPreparados()= quirofanosPreparados
  method prepararQuirofanos(){quirofanosPreparados = true}
  method desarmarQuirofanos(){quirofanosPreparados = false}
  override method estaTranquila() = super() && !quirofanosPreparados
  override method recibirAmenaza(){
    super()
    self.prepararQuirofanos()
  }

}

class NaveCombateSigilosa inherits NaveDeCombate {
  override method estaTranquila() = super() && !visibilidad

  override method escapar() {
    super()
    self.desplegarMisiles()
    self.ponerseInvisible()
  }
  
}