// Required imports
import 'package:flutter/material.dart';

// Widget
class InputsPage extends StatefulWidget {
  const InputsPage({super.key});

  // State builder
  @override
  State<StatefulWidget> createState() {
    return _WidgetState();
  }
}

//Sólo permite datos de una lista predefinida
enum SingingCharacter {
  lafayette,
  jefferson,
  luisito,
} //No puede ser declarado dentro de clases.

// State
class _WidgetState extends State<InputsPage> {
  // Variables
  String _email = '';
  String _name = '';
  String _password = '';
  String date = '';
  String option = '';
  String radioButton = '';

  /* 'TextEditingController' es una interface que permite controlar de forma
   * dinámica el valor de un TextField. Al actualizarse el controlador, llama
   * al listener del input asociado y de esa forma actualiza su valor también
   */
  final TextEditingController _datepickerController = TextEditingController();

  static const List<String> list = <String>[
    'Opción 1',
    'Opción 2',
    'Opción 3',
    'Opción 4',
    'Opción 5',
    'Opción 6',
    'Opción 7',
  ];

  SingingCharacter? _character = SingingCharacter.lafayette;
  // Widget builder
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inputs')),
      /* En una vista con inputs, es normal contener el 'body' en un ListView,
       * ya que en un Input de texto, el usuario despliega el teclado en la
       * pantalla y esto tiende a subir el contenido hacia arriba.
       */
      body: ListView(
        // padding:
        //     const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        children: [
          _nameInputTextBuilder(),
          _emailInputTextBuilder(),
          _passwordInputTextBuilder(),
          const Divider(),
          ListTile(title: Text('Tu nombre es: $_name')),
          ListTile(title: Text('Tu email es: $_email')),
          ListTile(
            //Formatear fecha
            title: Text('La fecha es: $date'),
          ),
          ListTile(title: Text('La opción es: $option')),
          ListTile(title: Text('Elección radio buttons: $radioButton')),
          const Divider(),
          _datepickerBuilder(),
          const Divider(),
          _dropdownBuilder(),
          const Divider(),
          _radioButton(),
        ],
      ),
    );
  }

  // Método que crea un input text para introducir el nombre
  Widget _nameInputTextBuilder() {
    /* TextField está pensado como un Widget independiente.
     * TextFormField está pensado para trabajar dentro de un formulario (Form)
     */
    return TextField(
      // 'autofocus' asigna el foco al input automáticamente al renderizar el Widget
      autofocus: true,
      /* 'textCapitalization' coloca en mayúsculas los valores del input según
       * la configuración deseada (por letra, por sentencia, etc)
       */
      // textCapitalization: TextCapitalization.sentences,
      // Es un tipo especial de Widget similar a BoxDecoration
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        // counter: Text('${_name.length} / 30'),
        labelText: 'Nombre completo',
        hintText: 'Fulanito de Tal',
        icon: const Icon(Icons.account_circle_outlined),
        suffixIcon: TextButton(
          onPressed: () {
            print(_name);
          },
          child: Icon(Icons.info_outline),
        ),
      ),
      /* 'onChanged' dispara una función por cada cambio en el valor que se
       * detecte en el input
       */
      onChanged: (inputValue) {
        setState(() {
          _name = inputValue.toUpperCase();
          inputValue = _name;
        });
      },
    );
  }

  // Método que crea un input text para introducir el email
  Widget _emailInputTextBuilder() {
    return TextField(
      /* 'keyboardType' define el tipo de despliegue del input text en cuanto
       * al teclado. Por ejemplo, en 'number', despliega el teclado solo para
       * números, en 'emailAddress' despliega para correo electrónico, etc.
       */
      autofocus: true, //Se posiciona en el primer widget con autofocus
      // keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        labelText: 'Correo electrónico',
        labelStyle: const TextStyle(color: Colors.green),
        hintText: 'julian@Kuvuni.com',
        helperText: 'Introduce un email válido.',
        icon: const Icon(Icons.email_outlined),
        suffixIcon: const Icon(Icons.info_outline),
      ),
      onChanged: (inputValue) {
        setState(() {
          _email = inputValue;
        });
      },
    );
  }

  // Método que crea un input text para introducir la contraseña
  Widget _passwordInputTextBuilder() {
    return TextField(
      keyboardType: TextInputType.datetime,
      // 'obscureText' permite ocultar los caracteres escritos en el input
      obscureText: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        labelText: 'Contraseña',
        icon: const Icon(Icons.vpn_key_outlined),
      ),
      onChanged: (inputValue) {
        setState(() {
          _password = inputValue;
          debugPrint(_password);
        });
      },
    );
  }

  // Método que crea un input para introducir una fecha
  Widget _datepickerBuilder() {
    return TextField(
      /* 'enableInteractiveSelection' impide seleccionar o colocar el cursor
       * del móvil sobre el TextField
       */
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        labelText: 'Fecha',
        suffixIcon: const Icon(Icons.event_outlined),
      ),
      onTap: () {
        /* La siguiente sentencia permite que al hacer click sobre el input,
         * este no le asigne el foco y así completar la ilusión de estar
         * abriendo un date picker
         */
        FocusScope.of(context).requestFocus(FocusNode());
        _openDatetimePicker();
      },
      // Controlador dinámico del valor del input
      controller: _datepickerController,
    );
  }

  // Método para abrir el Widget del date picker
  void _openDatetimePicker() async {
    /* Este método ocupa el BuildContext, pero Flutter permite inferirlo
     * automáticamente
     */

    //const Null pickedDate = null;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      // 'initialDate' posiciona el date picker en la fecha indicada
      initialDate: DateTime.now(),
      // 'firstDate' restringe el date picker no más antes de la fecha indicada
      firstDate: DateTime.parse('2019-12-31 15:00:00'),
      // 'lastDate' restringe el date picker no más después de la fecha indicada
      lastDate: DateTime.parse('2027-01-01 21:00:00'),
      /* 'locale' permite configurar el idioma del date picker. Para que Flutter
       * lo reconozca, se debe modificar el pubspec.yaml para este propósito,
       * además de
       */
      // locale: Locale('es', 'ES')
    );

    // Validando que se haya seleccionado una fecha
    if (pickedDate != null) {
      setState(() {
        // Guardando en una varibale la fecha seleccionada
        date = pickedDate.toString();
        debugPrint(date);
        // Actulizando el controlador del TextField
        // datepickerController.text = date;
      });
    }
  }

  // Método para crear un widget tipo dropdown button
  Widget _dropdownBuilder() {
    String dropdownValue = list.first;
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(height: 2, color: Colors.deepPurpleAccent),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          print(value);
          option = value!;
          // dropdownValue = value;  //Esto no funciona, quizá pasarle el index.
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
    );
  }

  Widget _radioButton() {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Opción 1'),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.lafayette,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
                radioButton = value.toString();
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Opción 2'),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.jefferson,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
                radioButton = value.toString();
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Opción 3'),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.luisito,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
                radioButton = value.toString();
              });
            },
          ),
        ),
      ],
    );
  }
}
