package ar.edu.celulares.repos

import ar.edu.celulares.domain.ModeloCelular
import java.math.BigDecimal
import java.util.List
import org.uqbar.commons.utils.Observable
import uqbar.arena.persistence.PersistentHome

@Observable
class RepoModelos extends PersistentHome<ModeloCelular> {

	new() {
		this.init
	}

	def void init() {
		this.createIfNotExists("NOKIA ASHA 501", 700f, true)
		this.createIfNotExists("LG OPTIMUS L5 II", 920f, false)
		this.createIfNotExists("LG OPTIMUS L3 II", 450f, true)
		this.createIfNotExists("NOKIA LUMIA 625", 350f, true)
		this.createIfNotExists("MOTOROLA RAZR V3", 350f, false)
	}
	
	def void createIfNotExists(String unaDescripcion, float unCosto, boolean siRequiereResumenCuenta) {
		if (this.get(unaDescripcion) != null) {
			return
		}
		var modelo = new ModeloCelular => [
			descripcion = unaDescripcion
			costo = new BigDecimal(unCosto)
			requiereResumenCuenta = siRequiereResumenCuenta
		]
		this.create(modelo)
	}

	def List<ModeloCelular> getModelos() {
		allInstances	
	}
	
	def ModeloCelular get(String descripcion) {
		modelos.findFirst [ modelo | modelo.descripcion.equals(descripcion) ]
	}

	override def Class<ModeloCelular> getEntityType() {
		typeof(ModeloCelular)
	}

	override def createExample() {
		new ModeloCelular()
	}

}