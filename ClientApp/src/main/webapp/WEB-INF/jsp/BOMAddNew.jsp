<%-- 
    Document   : BOMAddition
    Created on : Aug 19, 2017, 12:46:56 PM
   Author     : Supriya Kare
--%>
<!DOCTYPE html>
<html data-ng-app="myApp" >
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>BOM Entry</title>

        <script>

            var myApp = angular.module('myApp', ["ui.bootstrap.modal"]);
            myApp.controller("myCtrl", ['$scope', '$http', function ($scope, $http)
                {
                     $scope.populatecodeList();
                    $scope.populatecodeList = function () {
                       // var seas_code = $scope.seas_code;
                        var seas_code = "51";
                        $http.get('getCodeList', {params: {seas_code: seas_code}}).
                                success(function (response)
                                {
                                    $scope.codelist = response;

                                });
                    };
                  //  $scope.populatecodeList();

                }]);

        </script>
        <style>
            #heading {
                color: #fff;
                text-align: center;
                text-transform: uppercase;
                font-weight: bold;
                padding: 1em;
                margin-left: 70px;
            }
            .help-block, .help-inline{
                color:red;
            }
            .table-responsive {
                max-height:300px;
            }
            #someid tr td:nth-child(2){
                width:40%;
            }
            @media print
            {
                .noprint {display:none;}
            }
            p
            {
                padding: 0px;
                margin:0px;
            }
            input.ng-invalid-required{
                border-left: 5px solid #990000;
            }

            input.ng-valid-required{
                //border-left: 5px solid #009900;
            }

            legend {
                width:inherit; 
                padding:0 10px; 
                line-height:20px;
                font-size: 13px;
                border: 1px solid #333;
                margin-bottom:0px
            }

        </style>
    </head>
    <body  data-ng-controller="myCtrl">
               <div class="panel panel-info" style='width:80%;margin-left: 8%'>
            <div class="panel-heading">Fabric Entry </div>
            <div class="panel-body">
                <form  class="form-horizontal" name="myform" ng-submit="submit()" nonvalidate>  
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="control-label col-sm-1">Season Code</label>
                                <div class="input-group col-sm-4">
                                    <input class="form-control" id="seas_code" type="text" value="${seas_code}" ng-model="seas_code" ng-value="${seas_code}" readonly>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-7" >
                            <div class="form-group">
                                <label class="control-label col-sm-2">Code</label>
                                <div data-ng-init="populatecodeList()"  class=" input-group col-sm-5" >
                                      
                                        <!-- Link or button to toggle dropdown -->
                                        <div class="table-responsive" style="height:50%;width:80%">          
                                        <table class="table table-bordered">
                                            <thead>
                                                <tr><th>Fab Code</th>
                                                    <th>Fab Desc</th>
                                                    <th>MFABDESC</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr ng-repeat="code in codelist" >
                                                    <td>{{code.FAB_CODE}}</td>
                                                    <td>{{code.FAB_DESC}}</td>
                                                    <td>{{code.MFAB_DESC}}</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                            </div>
                        </div>
                    </div>
            </div>
            <div class="col-md-2" >
                <div class="form-group">
                    <input type="text"  id="seasonbean.seas_desc"  ng-init=" " readonly ng-model="seasonbean.seas_desc" ng-value="data.seas_desc" class="form-control" style="border:0px"/>

                </div>
            </div>
        </div>

    </div>
</div>


</form>
</body>
</html>
