package ar.edu.celulares.domain

import java.math.BigDecimal
import org.uqbar.commons.model.Entity
import org.uqbar.commons.utils.TransactionalAndObservable
import uqbar.arena.persistence.annotations.PersistentClass
import uqbar.arena.persistence.annotations.PersistentField

@TransactionalAndObservable
@PersistentClass
class ModeloCelular extends Entity {
	
	@Property String descripcion
	@Property BigDecimal costo
	@Property Boolean requiereResumenCuenta  // FED: boolean tiene problemas
	
	new(){
	}
	
	new(String unaDescripcion, double unCosto) {
		this(unaDescripcion, unCosto, false)
	}

	new(String unaDescripcion, double unCosto, boolean siRequiereResumenCuenta) {
		_descripcion = unaDescripcion
		_costo = new BigDecimal(unCosto)
		_requiereResumenCuenta = siRequiereResumenCuenta
	}

	@PersistentField
	def getDescripcion() {
		_descripcion
	}
	
	def String getDescripcionEntera() {
		descripcion + " ($ " + costo + ")"
	}
	
	@PersistentField
	def getCosto() {
		_costo
	}
	
	@PersistentField
	def getRequiereResumenCuenta() {
		_requiereResumenCuenta
	}

	override toString() {
		return descripcionEntera
	}
	
}