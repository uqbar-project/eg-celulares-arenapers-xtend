package ar.edu.celulares.domain

import org.uqbar.commons.model.Entity
import org.uqbar.commons.model.ObservableUtils
import org.uqbar.commons.model.UserException
import org.uqbar.commons.utils.TransactionalAndObservable
import uqbar.arena.persistence.annotations.PersistentClass
import uqbar.arena.persistence.annotations.PersistentField
import uqbar.arena.persistence.annotations.Relation

@TransactionalAndObservable
@PersistentClass
class Celular extends Entity implements Cloneable {
	final int MAX_NUMERO = 1000

	@Property Integer numero
	@Property String nombre
	@Property ModeloCelular modeloCelular
	@Property Boolean recibeResumenCuenta

	new() {
	}

	new(String unNombre, Integer unNumero) {
		_nombre = unNombre
		_numero = unNumero
	}

	new(String unNombre, Integer unNumero, ModeloCelular unModeloCelular, boolean siRecibeResumenCuenta) {
		_nombre = unNombre
		_numero = unNumero
		_modeloCelular = unModeloCelular
		_recibeResumenCuenta = siRecibeResumenCuenta
	}

	// ********************************************************
	// ** Validacion
	// ********************************************************
	/**
	 * Valida que el celular esté correctamente cargado
	 */
	def void validar() {
		if (!this.ingresoNumero()) {
			throw new UserException("Debe ingresar número")
		}
		if (this.numero.intValue() <= this.MAX_NUMERO) {
			throw new UserException("El número debe ser mayor a " + this.MAX_NUMERO)
		}
		if (!this.ingresoNombre()) {
			throw new UserException("Debe ingresar nombre")
		}
		if (this.modeloCelular == null) {
			throw new UserException("Debe ingresar un modelo de celular")
		}
	}

	def ingresoNombre() {
		this.nombre != null && !this.nombre.trim().equals("")
	}

	def ingresoNumero() {
		this.numero != null
	}

	// ********************************************************
	// ** Getters y setters
	// ********************************************************
	@PersistentField
	def getNumero() {
		_numero
	}

	def void setNumero(Integer numero) {
		if (numero < 10000000) {
			throw new UserException("El número de celular es muy corto")
		}
		_numero = numero
	}

	@PersistentField
	def getNombre() {
		_nombre
	}

	@Relation
	def ModeloCelular getModeloCelular() {
		_modeloCelular
	}

	def void setModeloCelular(ModeloCelular modeloCelular) {
		_modeloCelular = modeloCelular
		this.setRecibeResumenCuenta(modeloCelular.getRequiereResumenCuenta())
	}

	def void setRecibeResumenCuenta(Boolean siRecibeResumenCuenta) {
		_recibeResumenCuenta = siRecibeResumenCuenta
		if (modeloCelular != null)
			ObservableUtils.firePropertyChanged(this, "habilitaResumenCuenta", !habilitaResumenCuenta)
	}

	@PersistentField
	def getRecibeResumenCuenta() {
		_recibeResumenCuenta
	}

	def getHabilitaResumenCuenta() {
		!modeloCelular.getRequiereResumenCuenta()
	}

	// ********************************************************
	// ** Misceláneos
	// ********************************************************
	override toString() {
		val result = new StringBuffer
		if (this.ingresoNombre) {
			result.append(this.nombre)
		} else {
			result.append("Celular sin nombre")
		}
		if (this.modeloCelular != null) {
			result.append(" - " + this.modeloCelular)
		} else {
			result.append(" - sin modelo")
		}
		if (this.ingresoNumero) {
			result.append(" - " + this.numero)
		} else {
			result.append(" - sin número")
		}
		if (this.recibeResumenCuenta) {
			result.append(" - recibe resumen de cuenta")
		} else {
			result.append(" - no recibe resumen de cuenta")
		}
		return result.toString()
	}

	override clone() {
		super.clone()
	}

	def copiarA(Celular destino) {
		destino.numero = this.numero
		destino.nombre = this.nombre
		destino.recibeResumenCuenta = this.recibeResumenCuenta
		destino.modeloCelular = this.modeloCelular
	}

}
