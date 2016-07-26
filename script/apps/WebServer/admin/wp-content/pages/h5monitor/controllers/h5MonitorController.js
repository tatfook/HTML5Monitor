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
                        template: 'connectInfoDialog', className: 'ngdialog-theme-plain',
                    });
                }     
            });
        }

        $scope.doServerStart = function () {
            var server = $("#server").val();
            var username = $("#username").val();
            var url = "ajax/H5Monitor?action=monitor_monitor_start&server=" + server + "&username=" + username;
            $http.get(url).then(function (response) {
                $scope.showScreenShot();
            });
        }

        $scope.showScreenShot = function () {
            if (angular.isDefined(pollTimer)) return;
            pollTimer = $interval(function () {
                $scope.doShowScreenShot();
            }, 3000);
        }
        
        $scope.showLargeScreenShot = function () {
            if (angular.isDefined(pollTimer)) return;
            ngDialog.open({
                template: 'showLargeScreenShot', className: 'ngdialog-theme-plain',
            });
            pollTimer = $interval(function () {
                $scope.showLargeImage();
            }, 3000);
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

        $scope.doShowLargeScreenShot = function () {
            var url = "ajax/H5Monitor?action=monitor_show_large_screen_shot";
            $http.get(url).then(function (response) {
                if (response.data) {
                    var imageData = response.data.imageData;
                    $scope.drawLargeImage(imageData);
                }
            });
        }

        $scope.showImageInfo = function () {
            var url = "";
        }

        $scope.addNewClient = function () {
            ngDialog.open({
                template: 'addNewClientDialog', className: 'ngdialog-theme-plain',
            });
        }
    }
})
