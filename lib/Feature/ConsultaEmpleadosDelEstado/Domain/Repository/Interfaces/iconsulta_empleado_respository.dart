
import 'package:consultas_y_contrataciones/Feature/ConsultaEmpleadosDelEstado/Domain/Entities/consulta_empleado_response_model.dart';
import 'package:consultas_y_contrataciones/Feature/ConsultaEmpleadosDelEstado/Domain/Entities/empleadoentity.dart';

abstract class IconsultaEmpleadoRespository {
  Future<ConsultaEmpleadoResponseModel> obtenerEmpleado(String cedula);
 
}