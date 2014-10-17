package ar.edu.celulares.ui

import ar.edu.celulares.applicationModel.BuscadorCelular
import ar.edu.celulares.domain.Celular
import java.awt.Color
import org.uqbar.arena.bindings.NotNullObservable
import org.uqbar.arena.layout.ColumnLayout
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.widgets.tables.Column
import org.uqbar.arena.widgets.tables.Table
import org.uqbar.arena.windows.Dialog
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner

/**
 * Ventana de búsqueda de celulares.
 *
 * @see BuscadorCelular el modelo subyacente.
 *
 * @author ?
 */
class BuscarCelularesWindow extends SimpleWindow<BuscadorCelular> {

	new(WindowOwner parent) {
		super(parent, new BuscadorCelular)
		modelObject.search()
	}

	/**
	 * El default de la vista es un formulario que permite disparar la búsqueda (invocando con super) Además
	 * le agregamos una grilla con los resultados de esa búsqueda y acciones que pueden hacerse con elementos
	 * de esa búsqueda
	 */
	override def createMainTemplate(Panel mainPanel) {
		title = "Buscador de Celulares"
		taskDescription = "Ingrese los parámetros de búsqueda"

		super.createMainTemplate(mainPanel)

		this.createResultsGrid(mainPanel)
		this.createGridActions(mainPanel)
	}

	// *************************************************************************
	// * FORMULARIO DE BUSQUEDA
	// *************************************************************************
	/**
	 * El panel principal de búsuqeda permite filtrar por número o nombre
	 */
	override def void createFormPanel(Panel mainPanel) {
		var searchFormPanel = new Panel(mainPanel)
		searchFormPanel.setLayout(new ColumnLayout(2))

		new Label(searchFormPanel) => [
			text = "Número"
			foreground = Color.BLUE
		]

		new TextBox(searchFormPanel).bindValueToProperty("numero")

		new Label(searchFormPanel) => [
			text = "Nombre del cliente"
			foreground = Color.BLUE
		]

		new TextBox(searchFormPanel).bindValueToProperty("nombre")
	}

	/**
	 * Acciones asociadas de la pantalla principal. Interesante para ver es cómo funciona el binding que mapea
	 * la acción que se dispara cuando el usuario presiona click Para que el binding sea flexible necesito
	 * decirle objeto al que disparo la acción y el mensaje a enviarle Contra: estoy atado a tener métodos sin
	 * parámetros. Eso me impide poder pasarle parámetros como en el caso del alta/modificación.
	 * Buscar/Limpiar -> son acciones que resuelve el modelo (BuscadorCelular) Nuevo -> necesita disparar una
	 * pantalla de alta, entonces lo resuelve la vista (this)
	 *
	 */
	override protected addActions(Panel actionsPanel) {
		new Button(actionsPanel)
			.setCaption("Buscar")
			.onClick [ | modelObject.search ] 
			.setAsDefault
			.disableOnError

		new Button(actionsPanel) //
			.setCaption("Limpiar")
			.onClick [ | modelObject.clear ]

		new Button(actionsPanel) //
			.setCaption("Nuevo Celular")
			.onClick [ | this.crearCelular ]
	}

	// *************************************************************************
	// ** RESULTADOS DE LA BUSQUEDA
	// *************************************************************************
	/**
	 * Se crea la grilla en el panel de abajo El binding es: el contenido de la grilla en base a los
	 * resultados de la búsqueda Cuando el usuario presiona Buscar, se actualiza el model, y éste a su vez
	 * dispara la notificación a la grilla que funciona como Observer
	 */
	def protected createResultsGrid(Panel mainPanel) {
		var table = new Table<Celular>(mainPanel, typeof(Celular))
		table.height = 200
		table.width = 450
		table.bindItemsToProperty("resultados")
		table.bindValueToProperty("celularSeleccionado")
		this.describeResultsGrid(table)

	}

	/**
	 * Define las columnas de la grilla Cada columna se puede bindear 1) contra una propiedad del model, como
	 * en el caso del número o el nombre 2) contra un transformer que recibe el model y devuelve un tipo
	 * (generalmente String), como en el caso de Recibe Resumen de Cuenta
	 *
	 * @param table
	 */
	def void describeResultsGrid(Table<Celular> table) {
		new Column<Celular>(table) => [
			title = "Nombre"
			fixedSize = 150
			bindContentsToProperty("nombre")
		]

		new Column<Celular>(table) //
			.setTitle("Número")
			.setFixedSize(100)
			.bindContentsToProperty("numero")

		new Column<Celular>(table)
			.setTitle("Modelo")
			.setFixedSize(150)
			.bindContentsToProperty("modeloCelular")

		new Column<Celular>(table)
			.setTitle("Recibe resumen de cuenta")
			.setFixedSize(50)
			.bindContentsToTransformer([celular | if (celular.recibeResumenCuenta) "SI" else "NO"])
	}

	def void createGridActions(Panel mainPanel) {
		var actionsPanel = new Panel(mainPanel)
		actionsPanel.setLayout(new HorizontalLayout)
		var edit = new Button(actionsPanel)
			.setCaption("Editar")
			.onClick [ | this.modificarCelular]

		var remove = new Button(actionsPanel)
			.setCaption("Borrar")
			.onClick [ | modelObject.eliminarCelularSeleccionado]
 
		// Deshabilitar los botones si no hay ningún elemento seleccionado en la grilla.
		var elementSelected = new NotNullObservable("celularSeleccionado")
		remove.bindEnabled(elementSelected)
		edit.bindEnabled(elementSelected)
	}

	// ********************************************************
	// ** Acciones
	// ********************************************************
	def void crearCelular() {
		this.openDialog(new CrearCelularWindow(this))
	}

	def void modificarCelular() {
		this.openDialog(new EditarCelularWindow(this, modelObject.celularSeleccionado))
	}

	def openDialog(Dialog<?> dialog) {
		dialog.onAccept[|modelObject.search]
		dialog.open
	}

}
