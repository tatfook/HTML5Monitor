angular.module('H5Monitor_App', ['ngStorage', 'ngDialog', 'bootstrapLightbox'])
.component("monitor", {
    templateUrl: "/wp-content/pages/h5monitor/templates/H5MonitorTemplate.html",
    controller: function ($scope, $http, $interval, ngDialog, Lightbox) {
        if (Page)
            Page.ShowSideBar(false);
        var pollTimer;

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
                $scope.showScreenShot();
            });
        }

        $scope.showScreenShot = function () {
            if (angular.isDefined(pollTimer)) return;
            pollTimer = $interval(function () {
                $scope.doShowScreenShot();
            }, 3000);
        }
        
        $scope.showLargeScreenShot = function (index) {
            //if (angular.isDefined(pollTimer)) return;
            Lightbox.openModal($scope.largeImages, index);
            pollTimer = $interval(function () {
                $scope.doShowLargeScreenShot();
            }, 3000);
        }

        $scope.drawImage = function (imageData) {
            $scope.imageUrl = "data:image/png;base64," + imageData;
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
                    $scope.largeImages = [ { 'url': "data:image/png;base64," + imageData, }, ];
                }
            });
        }

        $scope.showScreenShotInfo = function () {
            var url = "ajax/H5Monitor?action=monitor_show_screen_shot_info";
            $http.get(url).then(function (response) {
                $scope.screenShotInfo = response.data.remoteIP;
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
