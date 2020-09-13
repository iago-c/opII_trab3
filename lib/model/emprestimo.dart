import 'tipo_objeto.dart';
import 'pessoa.dart';

class Emprestimo {
  TipoObjeto _tipo;
  Pessoa _pessoa;
  String _descricaoObjeto;
  DateTime _data;
  bool _devolvido;
  Emprestimo(this._tipo, this._pessoa, this._descricaoObjeto, this._data,
      this._devolvido);

  TipoObjeto get tipo => _tipo;
  Pessoa get pessoa => _pessoa;
  String get descricao => _descricaoObjeto;
  DateTime get data => _data;
  bool get devolvido => _devolvido;

  Map getEmprestimo() {
    Map<String, dynamic> emprestimo = Map();
    emprestimo["tipo"] = _tipo;
    emprestimo["pessoa"] = _pessoa;
    emprestimo["descricaoObjeto"] = _descricaoObjeto;
    emprestimo["data"] = _data;
    emprestimo["devolvido"] = _devolvido;
    return emprestimo;
  }
}