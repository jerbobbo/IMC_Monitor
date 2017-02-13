//will be tab-graph in html tag
app.directive('tabGraph', function (d3Service, $window, GraphFactory) {

    return {
        restrict: 'E',
        scope: {
          where: '@',
          groupBy: '@',
          name: '@'
        },
        templateUrl: 'js/common/directives/tab-graph/tab-graph.html',

        link: function(scope, elem, attrs) {
          d3Service.d3().then(function(d3) {
            var margin = {top: 20, right: 20, bottom: 30, left: 50},
            width = 600 - margin.left - margin.right,
            height = 350 - margin.top - margin.bottom;
            // barHeight = parseInt(attrs.barHeight) || 20,
            // barPadding = parseInt(attrs.barPadding) || 5;

            var svg = d3.select(elem[0])
              .append("svg")
              ;
              // .style('width', '100%')
              // .attr('height', '300');

            // var g = svg.append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");


            // 2017-02-09T14:55:00.000Z
            // Browser onresize event
            window.onresize = function() {
            scope.$apply();
          };

          // // hard-code data
          // scope.data = [
          //   {name: "Greg", score: 98},
          //   {name: "Ari", score: 96},
          //   {name: 'Q', score: 75},
          //   {name: "Loser", score: 48}
          // ];

          // Watch for resize event
          scope.$watch(function() {
            return angular.element($window)[0].innerWidth;
          }, function() {
            scope.render(scope.data);
          });

          scope.render = function(data) {
            // remove all previous items before render
                svg.selectAll('*').remove();

                // If we don't pass any data, return out of the element
                if (!data) return;

                // var parseTime = d3.timeParse("%Y-%m-%dT%H:%M:%SZ");
                // var parseTime = d3.timeParse("%Y-%m-%dT%H:%M:%SZ");
                //
                // var x = d3.scaleTime()
                //   .rangeRound([0, width]);
                //
                // var y = d3.scaleLinear()
                //   .rangeRound([height, 0]);



                // setup variables
                // var width = d3.select(elem[0]).node().offsetWidth - margin,
                //     // calculate the height
                //     // height = scope.data.length * (barHeight + barPadding),
                //     height = +svg.attr("height") - margin.top - margin.bottom,
                    // Use the category20() scale function for multicolor support
                    // color = d3.scale.category20(),
                    // our xScale

                var parseTime = d3.timeParse("%Y-%m-%dT%H:%M:%S.%LZ");
                var yesterday = new Date();
                yesterday.setDate(yesterday.getDate() - 1);
                var today = new Date();
                var now = convertDateToUTC(today);

                var x = d3.scaleTime()
                  .domain([yesterday, now])
                  .rangeRound([0, width]),
                y = d3.scaleLinear()
                  .domain([0, 100])
                  .rangeRound([height, 0]),
                xAxis = d3.axisBottom()
                  .scale(x),
                yAxis = d3.axisLeft()
                  .scale(y);

                // gridlines in x axis function
                function make_x_gridlines() {
                    return d3.axisBottom(x)
                        .ticks(5);
                }

                // gridlines in y axis function
                function make_y_gridlines() {
                    return d3.axisLeft(y)
                        .ticks(10);
                }

                var area = d3.area()
                  .x(function(d) { return x(parseTime(d.batch_time)); })
                  .y0(height)
                  .y1(function(d) { return y(100*d.completed/d.originSeiz); });

                var asrm = d3.line()
                .x(function(d) { return x(parseTime(d.batch_time)); })
                .y(function(d) { return y(100*d.completed/d.originAsrmSeiz); });

                svg.attr('width', width + margin.left + margin.right)
                    .attr('height', height + margin.top + margin.bottom);

                var t = d3.transition()
                  .duration(1000)
                  .ease(d3.easeLinear);

                var g = svg.append('g')
                    .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')');

                // // add the X gridlines
                // g.append("g")
                // .attr("class", "grid")
                // .attr("transform", "translate(0," + height + ")")
                // .call(make_x_gridlines()
                //     .tickSize(-height)
                //     .tickFormat("")
                // );

                // add the Y gridlines
                g.append("g")
                .attr("class", "grid")
                .call(make_y_gridlines()
                    .tickSize(-width)
                    .tickFormat("")
                );


                g.append('path')
                  .datum(data)
                  .attr('d', area)
                    .style('fill', '#fff')
                  .transition(t)
                    .style('fill', '#4ca3bd');
                  // .attr('class', 'area')

                g.append('path')
                  .datum(data)
                  .attr('d', asrm)
                  .attr('class', 'asrm')
                  .transition(t)
                    .style('stroke', '#000');
                  // .call(transition);

                g.append('g')
                  .attr('class', 'x axis')
                  .attr('transform', 'translate(0,' + height + ')')
                  .call(xAxis);

                g.append('g')
                  .attr('class', 'y axis')
                  .call(yAxis);

                function transition(path) {
                  path.transition()
                      .duration(7500)
                      .attrTween("stroke-dasharray", tweenDash)
                      .each("end", function() { d3.select(this).call(transition); });
                }

                function tweenDash() {
                  var l = this.getTotalLength(),
                      i = d3.interpolateString("0," + l, l + "," + l);
                  return function(t) { return i(t); };
                }


                // g.append('g')
                //   .attr('transform', 'translate(0,' + height + ')')
                //   .call(d3.axisBottom(xScale));

              };
              scope.render(scope.data);

              function convertDateToUTC(date) {
                return new Date(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate(), date.getUTCHours(), date.getUTCMinutes(), date.getUTCSeconds());
              }

            });

          },
        controller: function($scope, GraphFactory) {
          console.log('where:', $scope.where);
          console.log('groupBy:', $scope.groupBy);
          console.log('scope:', $scope);

          var params = $scope.where + '&groupBy=' + $scope.groupBy;
          GraphFactory.getData(params)
          .then(function(results) {
            $scope.data = results;
            // $scope.$digest();
            // $scope.render($scope.data);
          });
        }
    };

});
