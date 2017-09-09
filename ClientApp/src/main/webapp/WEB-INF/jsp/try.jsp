<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>    

<!DOCTYPE html>  
<html>  
    <head>
        <script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>  
       
        <script>
            var myApp = angular.module('myApp', []);
            myApp.controller("myCtrl", function ($scope, $http)
            {
                $scope.myFunc = function (serial) {
                    $http.get('getalldata1', {params: {serial: serial}}).
                            success(function (data) {
                                $scope.emp = data;
                            });
                };
                $scope.Mod_Date = function (serial, delv_date)
                {
                    var newdate = document.getElementById("delv_date").value;
                    $http.get('http://localhost:8080/ClientApp/modDelivery_date', {params: {serial: serial, delv_date: newdate}}).
                            success(function (data) {

                                $scope.emp = data;
                            });
                };
                $scope.getSeasonDesc = function (seas_code)
                {
                    var seas_code = document.getElementById("seas_code").value;
                    if(seas_code!="")
                    {
                    $http.get('http://localhost:8080/ClientApp/getseasondesc', {params: {seas_code: seas_code}}).
                            success(function (response) {

                                $scope.season = response;

                            });
                        }
                };
            });

        </script>  
    </head>
    <body data-ng-app="myApp">  
        <div data-ng-controller="myCtrl">  
            <form:form name="myForm">
                <table> 
                    <tr>
                        <td><form:label path="seasonbean.seas_code" >Season Code</form:label>
                            
                            <form:select path="seasonbean.seas_code" id="seas_code" ng-change="getSeasonDesc()" ng-model="seas_code">
                             <form:option value="" label="Select" />
                             <form:options items="${seasonList}" itemValue="seas_code" itemLabel="seas_code" />
                            </form:select>
                            <span ng-show="myForm.seas_code.$touched && myForm.seas_code.$invalid || myForm.seas_code.$error.required || mForm.$submitted ">The name is required.</span>
                           
                            <form:input path="seasonbean.seas_desc" id="seas_desc" readonly="true"  ng-model="seas_desc" ng-value="season"/>
                        </td>
                    </tr>
                    <tr><td>
                Serial <input type="number" min="0" name="serial" ng-model="serial"  placeholder="Enter Serial" required/>
                <span ng-show="myForm.serial.$touched && myForm.serial.$invalid && myForm.serial.$error.required" style="color: red">Serial No.is required.</span>
           
                        </td>
                    </tr>
                    <tr><td><input type="reset"/></td></tr>
                </table>
                 </form:form>     
            <button ng-click="myFunc(serial)" ng-disabled="myForm.serial.$error.required">Get Data</button>                       
            Results:
            <table>
                <!-- assuming our search returns an array of users matching the search -->
                <tbody ng-repeat="e in emp">
                    <tr><td> Buyer Code:  {{e.buyer_code}}</td></tr>
                    <tr> <td>Style No:  {{e.style_no}}</td></tr>
                    <tr><td>order Quantity {{e.order_qty}}</td></tr>
                    <tr><td> Delivery Date {{e.delv_date|date:'dd-MMM-y' }}</td></tr>

                </tbody>
                <tr> <td> New Delivery Date  <input type="date" ng-model="delv_date" id="delv_date" /></td></tr>
            </table>


            <button ng-click="Mod_Date(serial, delv_date)" ng-disabled="myForm.serial.$error.required">Modify Date</button>
        </div>

    </div>
</div>  

</body>  
</html>  