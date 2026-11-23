class Empleado{
    const habilidades = #{}
    const subordinados = []
    var property rol
    var salud

    method estaIncapacitado() = salud < rol.saludCritica()
    method sobrevive() = salud > 0
    method recibirDanio(cantidad){ salud -= cantidad }
    method conoceHabilidad(habilidad) = habilidades.contains(habilidad)
    method puedeUsarHabilidad(habilidad) =
        !self.estaIncapacitado() &&
        (self.conoceHabilidad(habilidad) || subordinados.any({subordinado => subordinado.puedeUsarHabilidad(habilidad)}))

    method aprenderHabilidades(nuevasHabilidades){ habilidades.addAll(nuevasHabilidades) }
    method cumplirMision(mision){ mision.serCumplidaPor(self) }// puedeSerCumplidaPor está en MISION
    
    // Solo si sobrevive "registra" la mision; lo que pasa depende del rol (polimorfismo)
    method completarMision(mision){
        if(self.sobrevive())
            rol.completarMision(self, mision) // Lo busca en cada rol y lo agrega en sí mismo
    }
}

class Espia{
    method saludCritica() = 15
    method completarMision(empleado, mision){
        empleado.aprenderHabilidades(mision.habilidadesRequeridas()) // Suma todas las habilidades y el set se ocupa de eliminar las repetidas
    }
}

class Oficinista{
    var cantidadEstrellas = 0

    method saludCritica() = 40 - 5 * cantidadEstrellas
    method completarMision(empleado, mision){
        cantidadEstrellas += 1
        if(cantidadEstrellas >= 3)
            empleado.rol(new Espia())
    }
}

// Un equipo entiende los mismos mensajes que un empleado, asi la mision los trata igual
class Equipo{
    const equipoEmpleados = #{}

    method puedeUsarHabilidad(habilidad) = equipoEmpleados.any({empleado => empleado.puedeUsarHabilidad(habilidad)})
    method recibirDanio(cantidad){ equipoEmpleados.forEach({empleado => empleado.recibirDanio(cantidad / 3)}) }
    method completarMision(mision){ equipoEmpleados.forEach({empleado => empleado.completarMision(mision)}) }
    method cumplirMision(mision){ mision.serCumplidaPor(self) }
}

class Mision{
    const property habilidadesRequeridas = #{}
    const peligrosidad

    method puedeSerCumplidaPor(quien) = habilidadesRequeridas.all({habilidad => quien.puedeUsarHabilidad(habilidad)})
    method serCumplidaPor(quien){
        self.validarCumplimiento(quien)
        quien.recibirDanio(peligrosidad)
        quien.completarMision(self)
    }
    method validarCumplimiento(quien){
        if(!self.puedeSerCumplidaPor(quien))
            self.error("No reune las habilidades requeridas para la mision")
    }
}
