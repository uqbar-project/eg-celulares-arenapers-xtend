package ar.edu.celulares.domain

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
	
	String descripcion
	BigDecimal costo
	Boolean requiereResumenCuenta  // FED: boolean tiene problemas
	
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

	@PersistentField
	def getDescripcion() {
		descripcion
	}
	
	def String getDescripcionEntera() {
		descripcion + " ($ " + costo + ")"
	}
	
	@PersistentField
	def getCosto() {
		costo
	}
	
	@PersistentField
	def getRequiereResumenCuenta() {
		requiereResumenCuenta
	}

	override toString() {
		return descripcionEntera
	}
	
}