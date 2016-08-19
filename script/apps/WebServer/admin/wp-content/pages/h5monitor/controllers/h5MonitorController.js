angular.module('H5Monitor_App', ['ngStorage', 'ngDialog'])
.component("monitor", {
    templateUrl: "/wp-content/pages/h5monitor/templates/H5MonitorTemplate.html",
    controller: function ($scope, $http, $interval, ngDialog) {
        if (Page)
            Page.ShowSideBar(false);

        var screenShotTimer;
        var largeScreenShotTimer;
        $scope.imageArray = {};

        $scope.doClientStart = function () {
            var server = $("#server").val();
            var url = "ajax/H5Monitor?action=monitor_client_start&server=" + server;
            $http.get(url).then(function (response) {
                if (response.data.status == 0) {
                    ngDialog.open({
                        id: 'connectInfoDialogID',
                        template: 'connectInfoDialog', className: 'ngdialog-theme-plain',
                        scope: $scope,
                    });
                }
            });
        }

        $scope.doServerStart = function () {
            var client = $("#client").val();
            var url = "ajax/H5Monitor?action=monitor_server_start&client=" + client;
            ngDialog.close("addNewClientDialogID");
            $http.get(url).then(function (response) {

            });
        }

        $scope.showScreenShot = function (index) {
            
            if (angular.isDefined(screenShotTimer)) return;
            if (angular.isDefined(largeScreenShotTimer)) {
                $interval.cancel(largeScreenShotTimer);
                largeScreenShotTimer = undefined;
            }
            $scope.screenShotCounter = 0;
            screenShotTimer = $interval(function () {
                $scope.showScreenShotInfo();
                $scope.doShowScreenShot(index);
                $scope.screenShotCounter = $scope.screenShotCounter + 1;
            }, 3000);   
        }
        
        $scope.showLargeScreenShot = function (index) {
            if (angular.isDefined(largeScreenShotTimer)) return;
            if (angular.isDefined(screenShotTimer)) {
                $interval.cancel(screenShotTimer);
                screenShotTimer = undefined;
            }
            $scope.largeScreenShotCounter = 0;
            ngDialog.open({
                id: 'showLargeScreenShotDialogID',
                template: 'showLargeScreenShotDialog', className: 'ngdialog-theme-plain',
                scope: $scope,
                preCloseCallback: function (value) {
                    $scope.showScreenShot(index);
                    return true;
                }
            }); 
            largeScreenShotTimer = $interval(function () {
                $scope.doShowLargeScreenShot(index);
                $scope.largeScreenShotCounter = $scope.largeScreenShotCounter + 1;
            }, 3000);
        }

        $scope.drawImage = function (imageData) {
            $scope.imageUrl = "data:image/png;base64," + imageData;
        }

        $scope.drawLargeImage = function (imageData) {
            $scope.largeImageUrl = "data:image/png;base64," + imageData;
        }

        $scope.doShowScreenShot = function (index) {
            var url = "ajax/H5Monitor?action=monitor_show_screen_shot&counter=" + $scope.screenShotCounter +"&index=" + index;
            $http.get(url).then(function (response) {
                if (response.data) {
                    $scope.imageArray = response.data;
                }
            });
            
        }

        $scope.doShowLargeScreenShot = function (index) {
            var url = "ajax/H5Monitor?action=monitor_show_large_screen_shot&counter=" + $scope.largeScreenShotCounter + "&index=" + index;
            $http.get(url).then(function (response) {
                if (response.data) {
                    var imageData = response.data.imageData;
                    $scope.drawLargeImage(imageData);
                }
            });
        }

        $scope.showScreenShotInfo = function () {
            var url = "ajax/H5Monitor?action=monitor_show_screen_shot_info";
            $http.get(url).then(function (response) {
                if (response.data) {
                    $scope.screenShotInfo = response.data;
                }
            });
        }

        $scope.addNewClient = function () {
            ngDialog.open({
                id: 'addNewClientDialogID',
                template: 'addNewClientDialog', className: 'ngdialog-theme-plain',
                scope:$scope,
            });
        }
    }
})
