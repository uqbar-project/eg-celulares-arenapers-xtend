package ar.edu.celularesPers.domain

import java.math.BigDecimal
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.Entity
import org.uqbar.commons.utils.TransactionalAndObservable
import uqbar.arena.persistence.annotations.PersistentClass
import uqbar.arena.persistence.annotations.PersistentField

@TransactionalAndObservable
@PersistentClass
@Accessors
class ModeloCelular extends Entity {
	
	@PersistentField String descripcion
	@PersistentField BigDecimal costo
	@PersistentField Boolean requiereResumenCuenta  // FED: boolean tiene problemas
	
	new(){
	}
	
	new(String unaDescripcion, double unCosto) {
		this(unaDescripcion, unCosto, false)
	}

	new(String unaDescripcion, double unCosto, boolean siRequiereResumenCuenta) {
		descripcion = unaDescripcion
		costo = new BigDecimal(unCosto)
		requiereResumenCuenta = siRequiereResumenCuenta
	}

	def String getDescripcionEntera() {
		descripcion + " ($ " + costo + ")"
	}
	
	override toString() {
		return descripcionEntera
	}

}