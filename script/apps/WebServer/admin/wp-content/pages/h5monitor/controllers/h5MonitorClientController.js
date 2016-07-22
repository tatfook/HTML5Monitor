angular.module('H5Monitor_App', ['ngStorage'])
.component("monitorClient", {
    templateUrl: "/wp-content/pages/h5monitor/templates/H5MonitorClientTemplate.html",
    controller: function ($scope, $http, $interval) {
        if (Page)
            Page.ShowSideBar(false);
        var pollTimer;
        $scope.doSend = function () {
            var txt = $("#txt").val();
            var url = "ajax/H5MonitorClient?action=monitor_send&txt=" + encodeURIComponent(txt);
            $http.get(url).then(function (response) {
            });
        }
        $scope.doStart = function () {
            var ip = $("#ip").val();
            var port = $("#port").val();
            var url = "ajax/H5MonitorClient?action=monitor_start&ip=" + ip + "&port=" + port;
            console.log(url);
            $http.get(url).then(function (response) {
                $scope.startTimer();
            });
        }
        $scope.doStop = function () {
            var url = "ajax/H5MonitorClient?action=monitor_stop";
            $http.get(url).then(function (response) {
            });
            $scope.stopTimer();
        }
        $scope.handleMessage = function (msgs) {
            $scope.msgs = msgs;
        }
        $scope.startTimer = function () {
            if (angular.isDefined(pollTimer)) return;
            pollTimer = $interval(function () {
                $scope.refreshMsg();
            }, 500);
        }
        $scope.refreshMsg = function () {
            $http.get("ajax/H5MonitorClient?action=monitor_poll_msg").then(function (response) {
                var msgs = response.data.msgs;
                $scope.handleMessage(msgs);
                console.log(msgs);
            });
        }
        $scope.stopTimer = function () {
            if (angular.isDefined(pollTimer)) {
                $interval.cancel(pollTimer);
                pollTimer = undefined;
            }
        }
        $scope.drawImage = function (imageData) {
            var img = document.getElementById("screen_shot_image");
            img.src = "data:image/png;base64," + imageData;
        }
        $scope.doTakeScreenShot = function () {
            var width = $("#img_width").val();
            var height = $("#img_height").val();
            var url = "ajax/H5MonitorClient?action=monitor_take_screen_shot&width=" + width + "&height=" + height;
            $http.get(url).then(function (response) {
                if (response.data) {
                    var imageData = response.data.imageData;
                    var imageSize = response.data.imageSize;
                    $scope.drawImage(imageData);
                }

            });
        }
        
    }
    })
