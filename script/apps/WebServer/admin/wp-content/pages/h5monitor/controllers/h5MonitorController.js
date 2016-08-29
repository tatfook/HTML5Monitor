angular.module('H5Monitor_App', ['ngStorage', 'ngDialog'])
.component("monitor", {
    templateUrl: "/wp-content/pages/h5monitor/templates/H5MonitorTemplate.html",
    controller: function ($scope, $http, $interval, $timeout, ngDialog) {
        if (Page)
            Page.ShowSideBar(false);

        var screenShotTimer;
        var largeScreenShotTimer;
        var clientPingTimer;
        $scope.screenShotArray = {};

        $scope.doClientStart = function () {
            var server = $("#server").val();
            var url = "ajax/H5Monitor?action=monitor_client_start&server=" + server;
            $http.get(url).then(function (response) {

            });

            clientPingTimer = $interval(function () {
                $scope.doClientPing();
            }, 50);

            $timeout(function () {
                $interval.cancel(clientPingTimer);
                clientPingTimer = undefined;
                ngDialog.close("connectSuccessDialogID");
            }, 1500);
        }

        $scope.doClientPing = function () {
            if ($scope.clientPingStatus) return;
            var url = "ajax/H5Monitor?action=monitor_client_ping_status";
            $http.get(url).then(function (response) {
                $scope.clientPingStatus = response.data.pingSuccess;
                if (response.data.pingSuccess) {
                    ngDialog.open({
                        id: 'connectSuccessDialogID',
                        template: 'connectSuccessDialog', className: 'ngdialog-theme-plain',
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

        // Now timer is 1000 ms, it can be reset, but it should be larger than the client send msg timer
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
            }, 1000);   
        }

        // Now timer is 1000 ms, it can be reset, but it should be larger than the client send msg timer
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
            }, 1000);
        }

        $scope.drawScreenShot = function (screenShotData) {
            $scope.screenShotUrl = "data:image/png;base64," + screenShotData;
        }

        $scope.drawLargeScreenShot = function (screenShotData) {
            $scope.largeScreenShotUrl = "data:image/png;base64," + screenShotData;
        }

        $scope.doShowScreenShot = function (index) {
            var url = "ajax/H5Monitor?action=monitor_show_screen_shot&counter=" + $scope.screenShotCounter +"&index=" + index;
            $http.get(url).then(function (response) {
                if (response.data) {
                    $scope.screenShotArray = response.data;
                }
            });
            
        }

        $scope.doShowLargeScreenShot = function (index) {
            var url = "ajax/H5Monitor?action=monitor_show_large_screen_shot&counter=" + $scope.largeScreenShotCounter + "&index=" + index;
            $http.get(url).then(function (response) {
                if (response.data) {
                    var largeScreenShotData = response.data.largeScreenShotData;
                    $scope.drawLargeScreenShot(largeScreenShotData);
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
