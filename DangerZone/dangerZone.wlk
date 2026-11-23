class Empleado{
    const habilidades = []
    var tipoEmpleado

    method salud()
    method saludCritica()
    method estaIncapacitado(empleado) = tipoEmpleado.salud() < tipoEmpleado.saludCritica()
    method conoceHabilidad(habilidad) = habilidades.any(habilidad)
    method puedeUsarHabilidad(empleado, habilidad) = !self.estaIncapacitado(empleado) && self.conoceHabilidad(habilidad)

    method misionCompleta() = false
    

}

class Espia{

    method saludCritica() = 15
    method misionCompleta() = true

    method aprenderHabilidad(empleado, habilidad){
        if(!empleado.conoceHabilidad(habilidad) && self.misionCompleta())
            empleado.habilidades().add(habilidad)
    }
}

class Oficinista{
    var cantidadEstrellas = 0
    
    method saludCritica() = 40 - 5 * cantidadEstrellas
    method misionCompleta() = true

    method ganarEstrella(){
        if(self.misionCompleta()) cantidadEstrellas += 1
    }

}