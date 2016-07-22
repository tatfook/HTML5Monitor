angular.module('H5Monitor_App', ['ngStorage'])
.component("monitorServer", {
    templateUrl: "/wp-content/pages/h5monitor/templates/H5MonitorServerTemplate.html",
    controller: function ($scope, $http, $interval) {
        if (Page)
            Page.ShowSideBar(false);
        var pollTimer;
        $scope.doSend = function () {
            var txt = $("#txt").val();
            var url = "ajax/H5MonitorServer?action=monitor_server_send&txt=" + encodeURIComponent(txt);
            $http.get(url).then(function (response) {
            });
        }
        $scope.doStart = function () {
            var ip = $("#ip").val();
            var port = $("#port").val();
            var url = "ajax/H5MonitorServer?action=monitor_server_start&ip=" + ip + "&port=" + port;
            $http.get(url).then(function (response) {
                $scope.startTimer();
            });
        }
        $scope.doStop = function () {
            var url = "ajax/H5MonitorServer?action=monitor_server_stop";
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
            $http.get("ajax/H5MonitorServer?action=monitor_server_poll_msg").then(function (response) {
                var msgs = response.data.msgs;
                $scope.handleMessage(msgs);
            });
        }
        $scope.stopTimer = function () {
            if (angular.isDefined(pollTimer)) {
                $interval.cancel(pollTimer);
                pollTimer = undefined;
            }
        }
    }
})
