import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'file:///D:/Projetos_OpII/trab3_opii_iagocosta/lib/persistence/manipula_arquivo.dart';
import 'package:trab3_opii_iagocosta/model/pessoa.dart';
import 'package:trab3_opii_iagocosta/model/tipo_objeto.dart';
import 'package:trab3_opii_iagocosta/model/emprestimo.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ManipulaArquivo manipulaArquivo = ManipulaArquivo();

  final _tipoObjetoController = TextEditingController();
  final _pessoaController = TextEditingController();
  final _descricaoController = TextEditingController();
  DateTime _dataInfo = DateTime.now();
  Map<String, dynamic> _ultimoRemovido;
  int _ultimoRemovidoPos;

  List _emprestimoList = [];

  @override
  void initState() {
    super.initState();
    manipulaArquivo.readEmprestimo().then((dado) {
      setState(() {
        _emprestimoList = json.decode(dado);
      });
    });
  }

  void _addEmprestimo() {
    setState(() {
      Map<String, dynamic> novoEmprestimo = Map();
      Emprestimo emprestimo = Emprestimo(
          TipoObjeto(_tipoObjetoController.text),
          Pessoa(_pessoaController.text),
          _descricaoController.text,
          _dataInfo,
          false);
      novoEmprestimo = emprestimo.getEmprestimo();
      _tipoObjetoController.text = "";
      _pessoaController.text = "";
      _descricaoController.text = "";
      _dataInfo = DateTime.now();
      _emprestimoList.add(novoEmprestimo);
      manipulaArquivo.saveEmprestimo(_emprestimoList);
    });
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _emprestimoList.sort((a, b) {
        if (a["devolvido"] && !b["devolvido"])
          return 1;
        else if (!a["devolvido"] && b["devolvido"])
          return -1;
        else
          return 0;
      });
      manipulaArquivo.saveEmprestimo(_emprestimoList);
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Empréstimos"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(17.0, 0.0, 17.0, 0.0),
              child: Row(
                children: [
                  FlatButton(
                    child: Row(
                      children: <Widget>[
                        Text(
                          DateFormat('dd/MM/yyyy').format(_dataInfo) +
                              " às " +
                              DateFormat('kk:mm').format(_dataInfo),
                        ),
                        Icon(
                          Icons.calendar_today,
                        ),
                      ],
                    ),
                    onPressed: () async {
                      final dataSelecionada = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2050),
                        helpText:
                        "Escolha a data em que o empréstimo aconteceu",
                        confirmText: "CONFIRMAR",
                      );
                      if (dataSelecionada != null &&
                          dataSelecionada != _dataInfo) {
                        setState(() {
                          _dataInfo = dataSelecionada;
                        });
                      }
                    },
                  ),
                ],
              )),
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 0.0, 17.0, 0.0),
            child: Expanded(
              child: TextField(
                controller: _tipoObjetoController,
                decoration: InputDecoration(
                  labelText: "Tipo do objeto",
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 0.0, 17.0, 0.0),
            child: Expanded(
              child: TextField(
                controller: _descricaoController,
                decoration: InputDecoration(
                    labelText: "Descrição do objeto",
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 0.0, 17.0, 0.0),
            child: Expanded(
              child: TextField(
                controller: _pessoaController,
                decoration: InputDecoration(
                    labelText: "Pedinte",
                ),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 10.0),
                  itemCount: _emprestimoList.length,
                  itemBuilder: buildItem),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ButtonTheme(
                minWidth: 360,
                height: 50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0)),
                child: RaisedButton(
                  onPressed: () {
                    _addEmprestimo();
                  },
                  child: Text(
                    "Adicionar empréstimo",
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget buildItem(BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: Theme(
        data: ThemeData(unselectedWidgetColor: Colors.blueAccent),
        child: CheckboxListTile(
          title: Text(
                _emprestimoList[index]["tipo"].nome +
                " - \"" +
                _emprestimoList[index]["descricaoObjeto"] +
                "\" por \"" +
                _emprestimoList[index]["pessoa"].nome +
                "\" no dia " +
                DateFormat('dd/MM/yyyy').format(_emprestimoList[index]["data"]) +
                " às " +
                DateFormat('kk:mm').format(_emprestimoList[index]["data"]),
          ),
          value: _emprestimoList[index]["devolvido"],
          secondary: CircleAvatar(
            child: Icon(_emprestimoList[index]["devolvido"]
                ? Icons.check
                : Icons.error),
          ),
          onChanged: (c) {
            setState(() {
              _emprestimoList[index]["devolvido"] = c;
              manipulaArquivo.saveEmprestimo(_emprestimoList);
            });
          },
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          _ultimoRemovido = Map.from(_emprestimoList[index]);
          _ultimoRemovidoPos = index;
          _emprestimoList.removeAt(index);

          manipulaArquivo.saveEmprestimo(_emprestimoList);

          final snack = SnackBar(
            content: Text(
                "Emprestimo \"${_ultimoRemovido["descricaoObjeto"]}\" removido!"),
            action: SnackBarAction(
                label: "Desfazer",
                onPressed: () {
                  setState(() {
                    _emprestimoList.insert(_ultimoRemovidoPos, _ultimoRemovido);
                    manipulaArquivo.saveEmprestimo(_emprestimoList);
                  });
                }),
            duration: Duration(seconds: 4),
          );

          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snack);
        });
      },
    );
  }
}