<%-- 
    Document   : NormalOrderEntry
    Created on : Jul 6, 2017, 9:23:46 AM
    Author     : Supriya Kare
--%>



<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>    
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html data-ng-app="myApp" >
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Fab Rate/Emb Rate Entry</title>

        <script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>  
        <script src="<c:url value="/resources/js/app.js" />"></script>
        <script src="<c:url value="/resources/js/angular-ui-bootstrap-modal1.js" />"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/angular-filter/0.5.16/angular-filter.js"></script>  
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <link href="<c:url value="/resources/css/bootstrap.min.css" />" rel="stylesheet">
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.js"></script>
        <link rel="stylesheet" type="text/css href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/css/bootstrap-multiselect.css"/>
              <link href="<c:url value="/resources/css/bootstrap.css" />" rel="stylesheet">

        <link href="<c:url value="/resources/css/modalfieldset.css" />" rel="stylesheet">
        <script>

            var myApp = angular.module('myApp', ["ui.bootstrap.modal"]);
            myApp.controller("myCtrl", ['$scope', '$http', function ($scope, $http)
                {

                    $scope.formdata = {};
                    $scope.isDisabled = false;
                    $scope.forallDisable = false;
                    $scope.call= function(name)
                    {
                        alert(name);
                    };



                }]);


        </script>

        <style>
            #heading {
                background: #D9A9D0;
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
      input.ng-invalid-required,select.ng-invalid-required{
  border-left: 5px solid #990000;
}

input.ng-invalid-required,select.ng-valid-required{
  border-left: 5px solid #009900;
}

legend {
    width:inherit; 
    padding:0 10px; 
    
    border: 2px solid #333;
}

        </style>
    </head>
    <body  data-ng-controller="myCtrl">
        <nav class="navbar navbar-inverse">
            <div class="container-fluid noprint">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>                        
                    </button>
                    <a class="navbar-brand" href="#">Client Module</a>
                </div>
                <div class="collapse navbar-collapse" id="myNavbar">
                    <ul class="nav navbar-nav">
                        <li class="active"><a href="index.jsp">Home</a></li>
                        <li class="dropdown">
                            <a class="dropdown-toggle" data-toggle="dropdown" href="#">Master <span class="caret"></span></a>
                            <ul class="dropdown-menu">
                                <li><a href="DeliveryDateEntry">Normal Order Entry</a></li>
                                <li><a href="empform">Add Order</a></li>
                                <li><a href="viewemp">View Order</a></li>
                            </ul>
                        </li>
                        <li><a href="#">Entry</a></li>
                        <li><a href="#">Printing</a></li>
                    </ul>
                    <ul class="nav navbar-nav navbar-right">

                        <li><a href="#"><span class="glyphicon glyphicon-log-in"></span> Login</a></li>
                    </ul>
                </div>
            </div>
        </nav>  
        <div class="noprint">
            <div class="panel panel-info" style='width:80%;margin-left: 8%'>
                <div class="panel-heading">Fab Rate/Emb Rate Entry</div>
                <div class="panel-body">
                    <form  class="form-horizontal" name="myform" nonvalidate >  
                        
                        <div id="otherdetails">
                            <fieldset title="Other Details">
                                <legend>Other Details</legend>
                                <div class="row">
                                    <div class="col-md-4" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Hand Embroidery</label>
                                            <div class="input-group col-sm-5">
                                                <input type="number"  id="hand_emb"  name="hand_emb" ng-model="hand_emb" ng-value="otherdetails.HD_RATE"  class="form-control" />
                                                <span ng-show="myform.fab_rate.$touched && myform.fab_rate.$error.required" style="color: red">Required.</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Machine Embroidery</label>
                                            <div class="input-group col-sm-5">
                                                <input type="number"  id="mach_emb"  name="mach_emb" ng-model="mach_emb" ng-value="otherdetails.MC_RATE" class="form-control" />
                                                <span ng-show="myform.fab_rateIN.$touched && myform.fab_rateIN.$error.required" style="color: red">Required.</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Aari Embroidery</label>
                                            <div class="input-group col-sm-5">
                                                <input type="number"  id="aari_emb"  name="aari_emb" ng-model="aari_emb" ng-value="otherdetails.AR_RATE" class="form-control" />
                                                <span ng-show="myform.fab_rateIN.$touched && myform.fab_rateIN.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-2" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Others 1</label>
                                            <div class="input-group col-sm-5">
                                                <input type="number"  id="others1"  name="others1" ng-model="others1" ng-value="otherdetails.OTHERS"  class="form-control" />
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-2" data-ng-repeat="i in [2,3,4,5,6,7,8,9,10] ">
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Others {{i}}</label>
                                            <div class="input-group col-sm-5">
                                                <input type="number"  id="others[i]"  name="others[i]" ng-model="others[i]" ng-value="otherdetails.OTH{{i-1}}"  class="form-control" />
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                   
                                <div class="row">
                                    <div class="col-md-2" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Others Details 1</label>
                                            <div class="input-group col-sm-6">
                                                <select ng-model="othersd1" name="othersd1" id="othersd1" class="form-control" ng-required="others1">
                                                    <option value="">--Please Select--</option>
                                                    <option ng-repeat="work in worklist" value="{{work.NATURE_WK}}"><span style="margin-right: 40px">{{work.NATURE_DESC}}</span> <span style="margin-right: 40px"> {{work.NATURE_WK}}</span>  {{work.SEQ_NO}}</option>
                                                </select>
                                                <span ng-show="myform.othersd1.$dirty && myform.othersd1.$error.required" style="color: red">Required.</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-2" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Others Details 2</label>
                                            <div class="input-group col-sm-5">
                                                <select ng-model="othersd2" name="othersd2" id="othersd1" class="form-control" ng-required="others2">
                                                    <option value="">--Please Select--</option>
                                                    <option ng-repeat="work in worklist" value="{{work.NATURE_WK}}"><span style="margin-right: 40px">{{work.NATURE_DESC}}</span> <span style="margin-right: 40px"> {{work.NATURE_WK}}</span>  {{work.SEQ_NO}}</option>
                                                </select>
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-2" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Others Details 3</label>
                                            <div class="input-group col-sm-5">
                                                 <select ng-model="othersd3" name="othersd3" id="othersd3" class="form-control" ng-required="others3">
                                                    <option value="">--Please Select--</option>
                                                    <option ng-repeat="work in worklist" value="{{work.NATURE_WK}}"><span style="margin-right: 40px">{{work.NATURE_DESC}}</span> <span style="margin-right: 40px"> {{work.NATURE_WK}}</span>  {{work.SEQ_NO}}</option>
                                                </select>
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-2" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Others Details 4</label>
                                            <div class="input-group col-sm-5">
                                                <input type="text"  id="othersd4"  name="othersd4" ng-model="othersd4" ng-value="otherdetails.OTH3DESC"  class="form-control" />
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-2" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Others Details 5</label>
                                            <div class="input-group col-sm-5">
                                                <input type="text"  id="othersd5"  name="othersd5" ng-model="othersd5" ng-value="otherdetails.OTH4DESC"  class="form-control" />
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>

                                </div>                        
                                <div class="row">
                                    <div class="col-md-2" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Others Details 6</label>
                                            <div class="input-group col-sm-5">
                                                <input type="text"  id="othersd6"  name="othersd6" ng-model="othersd6" ng-value="otherdetails.OTH5DESC"  class="form-control" />
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-2" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Others Details 7</label>
                                            <div class="input-group col-sm-5">
                                                <input type="text"  id="othersd7"  name="othersd7" ng-model="othersd7" ng-value="otherdetails.OTH6DESC"  class="form-control" />
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-2" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Others Details 8</label>
                                            <div class="input-group col-sm-5">
                                                <input type="text"  id="othersd8"  name="othersd8" ng-model="othersd8" ng-value="otherdetails.OTH7DESC"  class="form-control" />
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-2" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Others Details 9</label>
                                            <div class="input-group col-sm-5">
                                                <input type="text"  id="othersd9"  name="othersd9" ng-model="othersd9" ng-value="otherdetails.OTH8DESC"  class="form-control" />
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-2" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Others Details 10</label>
                                            <div class="input-group col-sm-5">
                                                <input type="text"  id="othersd10"  name="othersd10" ng-model="othersd10" ng-value="otherdetails.OTH9DESC"  class="form-control" />
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </fieldset>
                        </div>

                        <button ng-click="reset()"  class="btn btn-primary">Reset</button>
                        <input type="text" name="tex1" ng-model="tex1" ng-value="model1" ng-click="call(this.name)" ng-bind="model1"/>
                          <input type="text" name="tex2" ng-model="tex2" ng-click="call(this.name)" ng-value="model1" />
                          
                          <select ng-model="model1" ng-required="required"  >
           <option value="NONE">select</option>
        <option value="aaa">aa</option>
        <option value="bb">bb</option>
    </select>
                           inputtt
<input type="text" ng-model="input.field1">

<input type="text" ng-model="input.field2" ng-required="angular.isDefined(input.field1) && input.field1.length > 0">
<span ng-show="myform.input.field2.$touched && myform.input.field2.$error.required" style="color: red">Required.</span>
other
<input type="text" data-ng-model="first"/>
    <input type="text" data-ng-model="second" data-ng-required="angular.isDefined(first)"/>
    <span ng-show="myform.second.$touched && myform.second.$error.required" style="color: red">Required.</span>
                    </form>
                   
                </div>
            </div>

        </div>
        <div modal="showModal" close="cancel()">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" ng-click="Cancel()">&times;</button>
            </div>
            <div class="modal-body">
                <fieldset >
                    <p>Do you want to enter  Embroidery Rates</p>
                    <fieldset>
                        <label class="radio-inline"> <input type="radio" id="mode" name="mode" ng-model="mode" value="Y"  />Yes</label>
                        <span ng-show="myform.mode.$touched && myform.mode.$error.required" style="color: red">Required.</span>

                        <label class="radio-inline"> <input type="radio" id="mode" name="mode" ng-model="mode" value="N" />No</label>
                    </fieldset>
                </fieldset>
            </div>
            <div class="modal-footer">
                <button class="btn btn-success" ng-click="Ok(mode)">OK</button>
                <button class="btn btn-success" ng-click="Cancel()">Cancel</button>

            </div>
        </div>

    </body>
</html>
