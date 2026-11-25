class Causa{
//    const caratula
    const property jueces = #{}
    var montoBase


    method perjuicioEconomico() = montoBase + self.montoExtra()
    method montoExtra()

    method tieneAmigos(juecesAmigos) = juecesAmigos.any({amigo => jueces.contains(amigo)})

    method perjuicioTramboliko() = self.perjuicioEconomico() > 5

    method aumentarMontoBase(monto){
        montoBase += monto
    }

}

class Soborno inherits Causa{
    const hayArrepentidos
    
    override method montoExtra() = if(hayArrepentidos) 1 else 2
}

class ObraPublica inherits Causa(montoBase = 3){
    method juecesMinimos() = jueces.size() <= 2
 
    override method montoExtra() = if(self.juecesMinimos()) 2 else 0

}

class Compleja inherits Causa{
    const subcausas = []

    method agregarSubcausa(causa) { subcausas.add(causa) }

    override method montoExtra() = subcausas.sum({causa => causa.montoExtra()})
}

class Funcionario{
    const property patrimonio
    var property puesto
    const causas = []
    const propuestas = []

//    method patrimonio()
    method comerseCausa(causa){
        if(!self.tienePatrimonio())
            throw new DomainException(message = "No se puede comer una causa alguien que no tiene un mango.")
        puesto.validarCondicion(self, causa)
        causas.add(causa)
    }
    method tienePatrimonio() = patrimonio > 0

    method saleEnMedios() { causas.forEach({causa => causa.aumentarMontoBase(0.1)}) }

    method aceptarPropuesta(propuesta){
        if(!puesto.aceptaTalCual(propuesta)){
            propuesta.extenderFecha()
        }
        propuestas.add(propuesta)
    }

    method quedaPegado() = causas.filter({causa => causa.perjuicioTramboliko()})
}

class PoderEjecutivo{
    const juecesAmigos = #{}
    const palabrasClave = ["aumento", "impuestos", "inflación"]

    method tieneJuecesAmigos(causa) = causa.tieneAmigos(juecesAmigos)
    method validarCondicion(funcionario, causa){
        if(!self.tieneJuecesAmigos(causa))
            throw new DomainException(message = "No tiene un juez amigo en la causa.")
    }

    method aceptaTalCual(propuesta) = 
        palabrasClave.any({palabra => propuesta.descripcion().toLowerCase().contains(palabra)})
//        propuesta.descripcion().toLowerCase().contains(palabrasClave.any({palabra => palabrasClave.contains(palabra)}))
}

class Ministro{
    method validarCondicion(funcionario, causa){
        if(!self.leDaElPatrimonio(funcionario, causa))
            throw new DomainException(message = "Su patrimonio es menor al 50% del perjuicio de la causa.")
    }

    method leDaElPatrimonio(funcionario, causa) = funcionario.patrimonio() > causa.perjuicioEconomico() * 0.5

    method aceptaTalCual(propuesta) = self.esPropuestaCorta(propuesta)
    method esPropuestaCorta(propuesta) = propuesta.propuestaCorta()
}

class Propuesta{
    const property descripcion
    const property fechaPresentacion
    var property   fechaCumplimentacion

    method propuestaCorta() = self.fechaPresentacion().plusYears(1) > self.fechaCumplimentacion()
    method extenderFecha(){
        fechaCumplimentacion = fechaCumplimentacion.plusYears(4)
    }
}