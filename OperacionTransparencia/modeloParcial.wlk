class Causa{
    const property caratula
    var property montoBase

    method prejuicioEconomico() = montoBase + self.montoExtra()
    method montoExtra()

    method aumentarMontoBase(monto){
        montoBase += monto
    }
}

class Soborno inherits Causa{
    var property hayArrepentidos = false
    
    override method montoExtra() = if(hayArrepentidos) 1 else 2
}

class ObraPublica inherits Causa(montoBase = 3){
    const property jueces = #{}

    override method montoExtra() = if(jueces.size() <= 2) 2 else 0
}

class Compleja inherits Causa{
    const subCausas = []

    method agregarSubCausa(causa){
        subCausas.add(causa)
    }
    override method montoExtra() = subCausas.sum({monto => monto.montoExtra()})
}

class Funcionario{
    var property patrimonioActual
    var property puesto
    const property juecesAmigos

    const causas = []
    const promesas = []

    method comerseCausa(causa){
        if(patrimonioActual <= 0)
            self.error("No se puede comer una causa alguien que no tiene un mango.")
        puesto.validarCausaAComerse(self, causa)
        causas.add(causa)
    }

    method teDejaPegado(causa) = causas.filter({monto => monto.prejuicioEconomico() > 5})

    method saleEnMedios(){
        causas.forEach({aumento => aumento.aumentarMontoBase(0.1)})
    }

    method escucharPropuesta(propuesta){
        const fecha = if(puesto.aceptaTalCual(propuesta))
                propuesta.fechaDeCumplimiento() 
            else 
                propuesta.fechaDeCumplimiento().plusYears(4)

        promesas.add(new Promesa(descripcion = propuesta.descripcion(), fechaCumplimiento = fecha ))
    }
}

object poderEjecutivo{
    const property palabrasClave = ["aumento", "impuestos", "inflacion"]

    method validarCausaAComerse(funcionario, causa){
        if(funcionario.juecesAmigos().intersection(causa.jueces()).isEmpty())
            self.error("Necesita un juez amigo para comerse una causa.")
    }

    method aceptarTalCual(propuesta) = palabrasClave.any({palabra => propuesta.descripcion().contains(palabra)})
}

object ministro {
  method validarCausaAComerse(funcionario, causa){
    if(funcionario.patrimonioActual() <= causa.prejuicioEconomico() * 0.5)
        self.error("El patrimonio debe ser mayor al 50% del prejuicio de la causa.")
  }

  method aceptarTalCual(propuesta) = propuesta.fechaCumplimiento() < propuesta.fechaPresentacion().plusYears(1)
}

class Propuesta{
    const property descripcion
    const property fechaPresentacion
    const property fechaCumplimiento
}

class Promesa{
    const property descripcion
    const property fechaCumplimiento
}