function convertirGrados() {
    event.preventDefault();
    var convertirCelsius = $("#celsius").is(":checked");
    var grados = $("input[name='grados']").val();
    console.log(convertirCelsius);
    if(convertirCelsius){
        CMContent.convertirGradosC(function(respuesta) {
                                   $("#respuestaGrados").html(respuesta + "° C");
                               },
                               function(error) {
                                   console.log(error);
                                   $("#respuestaGrados").html("Ocurrió un error en el servicio");
                               }, grados);
    } else {
        CMContent.convertirGradosF(function(respuesta) {
                                   $("#respuestaGrados").html(respuesta + "° F");
                               },
                               function(error) {
                                   console.log(error);
                                   $("#respuestaGrados").html("Ocurrió un error en el servicio");
                               }, grados);
    }
}