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
        <title>Normal Order Entry Form</title>
        

        <script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>  
        <script src="<c:url value="/resources/js/app.js" />"></script>
        <script src="<c:url value="/resources/js/angular-ui-bootstrap-modal1.js" />"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/angular-filter/0.5.16/angular-filter.js"></script>  
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.js"></script>
        <link rel="stylesheet" type="text/css href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/css/bootstrap-multiselect.css"/>
              <link href="<c:url value="/resources/css/bootstrap.css" />" rel="stylesheet">
        <link href="<c:url value="/resources/css/modalfieldset.css" />" rel="stylesheet">
        <script>

            var myApp = angular.module('myApp', []);
            myApp.controller("myCtrl", ['$scope', '$http', function ($scope, $http)
                {
                    $scope.serial="aaaa";
                    $scope.b="AUK";

                    $scope.submit = function (buyer) {
                      alert(buyer);
                        var formdata = {
                            'serial':$('#b').val(),
                            'buyer':$('#b').val()
                        };

                        var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
                        var response = $http.post('AddOrder', formdata, headers);
                        response.success(function (data, status, headers, config) {
                            console.log('status', status);
                            console.log('data', status);
                            console.log('headers', status);

                        });
                        response.error(function (data, status, headers, config) {
                            alert("Exception details: " + JSON.stringify({
                                data: $scope.formdata //used formData model here

                            }));
                            console.log(formdata);

                        });


                    };

                }]);

        </script>
        <style>
            .ng-invalid-required{
  border-left: 5px solid #990000;
}

.ng-valid-required{
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
        <div>
            <form ng-submit="submit(buyer)">
            Control #
            <input type="text"  id="serial" name="form.serial"  data-ng-model="serial"  ng-value="serial" class="form-control"/>

            <label class="control-label col-sm-4">Buyer Style</label>
             <input type="text"  id="b" name="form.buyer"  data-ng-model="buyer"  ng-value="b" class="form-control"/>
 
           <input type="submit" value="ADD ORDER" class="btn btn-primary"/>

       </form>
<form ng-submit="alert('hi')" name="myform" nonvalidate>
    <input type="text" data-ng-model="first"/>
    <input type="text" data-ng-model="second" ng-required="angular.isDefined(first) && first > 0" />
      <span ng-show="myform.first.length > 0 &&  myform.first.$touched && myform.second.$error.required">Required</span>
    <button type="submit" >Submit</button>
     <input type="textbox" ng-model="required" />
    <br>
    <select ng-model="model1" ng-required="required" >
           <option value="NONE">select</option>
        <option value="aaa">aa</option>
        <option value="bb">bb</option>
    </select>
    <span ng-show="myform.model1.$dirty && myform.model1.$error.required">Name is required!</span>
       <span ng-show="myform.model1.$dirty && myform.model1.$error.required" style="color: red">Required.</span>
   
       <br/>
       <input type="text" ng-model="model" id="input" name="input" ng-required="required" /><br>
      <span ng-show="myform.model.$dirty && myform.model.$error.required">Name is required!</span>
       <span ng-show="myform.model.$dirty && myform.model.$error.required" style="color: red">Required.</span>
       <br />
</form>
                
<div  ng-controller="myCtrl" class='container'>
<fieldset>
<legend>Two Group</legend>
  <input type="text" 
      ng-model="model.First" 
      ng-required="!model.Last" 
      class='form-control'/>
<br/>
<input type="text" 
      ng-model="model.Last"
      ng-required="!model.First"  
      class='form-control'/>
</fieldset>

<legend>Three Group</legend>
  <input type="text" 
      ng-model="fields.one" 
      ng-required="!(fields.two || fields.three)" 
      class='form-control' />
<br/>
<input type="text" 
      ng-model="fields.two"
      ng-required="!(fields.one || fields.three)" 
      class='form-control' />
<br/>
<input type="text" 
      ng-model="fields.three" 
      ng-required="!(fields.one|| fields.two)" 
      class='form-control' />
</fieldset>
</div>

</body>
  <input type="number"  id="tex1"  name="tex1" ng-model="tex1"  class="form-control"  />
                       <input type="number"  id="tex2"  name="tex2" ng-model="tex2"  class="form-control" ng-required="angular.isDefined(tex1) && tex1 > 0" />

                        <span ng-show="myform.tex1.length !==0 &&  myform.tex1.$touched && !myform.tex2.$error.required">Required</span>
                        </br>
</html>
