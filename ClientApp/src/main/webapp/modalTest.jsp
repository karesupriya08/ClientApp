<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html data-ng-app="myApp">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Normal Order Entry Form</title>

        <script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>  
          <script src="https://cdnjs.cloudflare.com/ajax/libs/angular-filter/0.5.16/angular-filter.js"></script>  
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <script src="https://rawgit.com/dwmkerr/angular-modal-service/master/dst/angular-modal-service.js"></script>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap3-dialog/1.34.7/css/bootstrap-dialog.min.css">
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap3-dialog/1.34.7/js/bootstrap-dialog.min.js"></script>
       
  <script>
   
            var myApp = angular.module('myApp', ["ui.bootstrap.modal"]);
            myApp.controller("myCtrl", ['$scope', '$http', function ($scope, $http)
                {
                    

                   BootstrapDialog.alert('hiiiiiiiiiiiiiiiiiiiiiiiii');

                }]);

        </script>
</head>
<body>

<div class="container">
    ${list}
  <h2>Basic Modal Example</h2>
  <!-- Trigger the modal with a button -->
  <button type="button" class="btn btn-info btn-lg" data-toggle="modal" data-target="#myModal">Open Modal</button>

  <!-- Modal -->
  <div class="modal fade" id="myModal" role="dialog">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title">Modal Header</h4>
        </div>
        <div class="modal-body">
          <p>Some text in the modal.</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        </div>
      </div>
      
    </div>
  </div>
  
</div>

</body>
</html>
   <div class="modal fade" id="myModal" role="dialog">
            <div class="modal-dialog">

                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">Add Colours</h4>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label class="control-label col-sm-5">Colour Code</label>
                            <div class="input-group col-sm-5">
                                <input class="form-control" type="text" value=""  ng-model="colour_code" ng-value="{{color.colour_code}}">

                                <div class="input-group-btn">
                                    <select  id="buyer_code" ng-model="colour_code"  required class="form-control" ng-change="getStyleNo(seas_code, buyer_code)" >
                                        <option value="" >Select Buyer</option>
                                        <option data-ng-repeat="color in normalorder.colourlist" value="{{color.colour_code}}">{{color.colour_code}}  {{color.colour_desc}}</option>
                                    </select> 
                                </div>
                            </div>

                        </div>
                        <div class="form-group">
                            <label class="control-label col-sm-5">Colour Quantity</label>
                            <input type="number" ng-model="col"
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        <div class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Modal title</h4>
                    </div>
                    <div class="modal-body">
                        <p>aaaaaaa</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-primary">Save changes</button>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div><!-- /.modal -->