angular.module('H5Monitor_App', ['ngStorage','ngDialog'])
.component("monitor", {
    templateUrl: "/wp-content/pages/h5monitor/templates/H5MonitorTemplate.html",
    controller: function ($scope, $http, $interval, ngDialog) {
        if (Page)
            Page.ShowSideBar(false);
        var pollTimer;

        $scope.doClientStart = function () {
            var server = $("#server").val();
            var username = $("#username").val();
            var url = "ajax/H5Monitor?action=monitor_client_start&server=" + server + "&username=" + username;
            $http.get(url).then(function (response) {
                if (response.data.status == 0) {
                    ngDialog.open({
                        template: '/wp-content/pages/h5monitor/templates/connectInfoTemplate.html', className: 'ngdialog-theme-plain',
                    });
                }
                    
            });
           
        }

        $scope.doServerStart = function () {
            var server = $("#server").val();
            var username = $("#username").val();
            var url = "ajax/H5Monitor?action=monitor_monitor_start&server=" + server + "&username=" + username;
            $http.get(url).then(function (response) {
                $scope.startTimer();
            });
        }

        $scope.startTimer = function () {
            if (angular.isDefined(pollTimer)) return;
            pollTimer = $interval(function () {
                $scope.doShowScreenShot();
            }, 1000);
        }
 
        $scope.drawImage = function (imageData) {
            var img = document.getElementById("screen_shot_image");
            img.src = "data:image/png;base64," + imageData;
        }

        $scope.drawLargeImage = function (imageData) {
            var img = document.getElementById("large_image");
            img.src = "data:image/png;base64," + imageData;
        }

        $scope.doShowScreenShot = function () {
            var url = "ajax/H5Monitor?action=monitor_show_screen_shot";
            $http.get(url).then(function (response) {
                if (response.data) {
                    var imageData = response.data.imageData;
                    $scope.drawImage(imageData);
                }
            });
        }

        $scope.showLargeImage = function () {
            var url = "ajax/H5Monitor?action=monitor_show_large_image";
            ngDialog.open({
                template: '/wp-content/pages/h5monitor/templates/showLargeImage.html', className: 'ngdialog-theme-plain',
            }); 
            $http.get(url).then(function (response) {
                if (response.data) {
                    var imageData = response.data.imageData;
                    $scope.drawLargeImage(imageData);
                }
            });
        }

        $scope.addNewClient = function () {
            ngDialog.open({
                template: '/wp-content/pages/h5monitor/templates/addNewClientTemplate.html', className: 'ngdialog-theme-plain',
            });
        }

    }
})
