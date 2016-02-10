package ar.edu.celularesPers.repos

import ar.edu.celularesPers.domain.ModeloCelular
import java.util.List
import org.uqbar.commons.utils.Observable
import uqbar.arena.persistence.PersistentRepo

@Observable
class RepoModelos extends PersistentRepo<ModeloCelular> {

	new() {
	}

	def void createIfNotExists(String unaDescripcion, float unCosto, boolean siRequiereResumenCuenta) {
		if (this.get(unaDescripcion) != null) {
			return
		}
		var modelo = new ModeloCelular(unaDescripcion, unCosto, siRequiereResumenCuenta)
		this.create(modelo)
	}

	def List<ModeloCelular> getModelos() {
		allInstances	
	}
	
	def ModeloCelular get(String descripcion) {
		modelos.findFirst [ modelo | modelo.descripcion.equals(descripcion) ]
	}

	override getEntityType() {
		typeof(ModeloCelular)
	}

	override createExample() {
		new ModeloCelular
	}

}