//will be tab-graph in html tag
app.directive('graph', function (d3Service, $window) {

    return {
        restrict: 'E',
        scope: {
          data: '=',
          type: '='
        },

        link: function(scope, elem, attrs) {
          console.log(scope);
          d3Service.d3().then(function(d3) {
            var margin = {top: 20, right: 20, bottom: 30, left: 50},
            width = 600 - margin.left - margin.right,
            height = 250 - margin.top - margin.bottom;

            var svg = d3.select(elem[0])
              .append("svg");

            window.onresize = function() {
            scope.$apply();
          };

          // Watch for resize event
          scope.$watch(function() {
            return angular.element($window)[0].innerWidth;
          }, function() {
            scope.render(scope.data);
          });


          scope.render = function(data) {
            console.log('scope.type:', scope.type);

            // remove all previous items before render
                svg.selectAll('*').remove();

                // If we don't pass any data, return out of the element
                if (!data) return;

                var parseTime = d3.timeParse("%Y-%m-%dT%H:%M:%S.%LZ");
                var yesterday = new Date();
                yesterday.setDate(yesterday.getDate() - 1);
                var today = new Date();
                var now = convertDateToUTC(today);

                var x = d3.scaleTime()
                  .domain([yesterday, now])
                  .rangeRound([0, width]),
                y = d3.scaleLinear()
                  .domain([0, scope.type.maxGraphHeight(data) ])
                  .rangeRound([height, 0]),
                xAxis = d3.axisBottom()
                  .scale(x),
                yAxis = d3.axisLeft()
                  .scale(y)
                  .ticks(5);

                // gridlines in x axis function
                function make_x_gridlines() {
                    return d3.axisBottom(x)
                        .ticks(10);
                }

                // gridlines in y axis function
                function make_y_gridlines() {
                    return d3.axisLeft(y)
                        .ticks(10);
                }

                var area = d3.area()
                  .x(function(d) { return x(parseTime(d.batch_time)); })
                  .y0(height)
                  .y1(function(d) { return y(scope.type.areaFunc(d)); });

                var lineData = d3.line()
                // .curve(d3.curveCatmullRomOpen)
                .x(function(d) { return x(parseTime(d.batch_time)); })
                .y(function(d) { return y(scope.type.lineFunc(d)); });
                // .y(scope.type.lineFunc);

                svg.attr('width', width + margin.left + margin.right)
                    .attr('height', height + margin.top + margin.bottom);

                var t = d3.transition()
                  .duration(1000)
                  .ease(d3.easeLinear);

                var g = svg.append('g')
                    .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')');

                // add the X gridlines
                g.append("g")
                .attr("class", "vertical-grid")
                .attr("transform", "translate(0," + height + ")")
                .call(make_x_gridlines()
                    .tickSize(-height)
                    .tickFormat("")
                );

                // add the Y gridlines
                g.append("g")
                .attr("class", "horizontal-grid")
                .call(make_y_gridlines()
                    .tickSize(-width)
                    .tickFormat("")
                );


                g.append('path')
                  .datum(data)
                  .attr('d', area)
                    .style('fill', '#fff')
                  .attr('class', 'area')
                  .transition(t)
                    .style('fill', '#3FBF83');
                //
                // var line = d3.line()
                //   .curve(d3.curveCatmullRomOpen)
                //   .x(function(d, i) { return x(i); })
                //   .y(function(d) {return y(d); });

                var path = g.append('path')
                  .attr('d', lineData(data))
                  .attr('stroke', '#333')
                  .attr('stroke-width', '1')
                  .attr('fill', 'none');

                g.append('g')
                  .attr('class', 'x axis')
                  .attr('transform', 'translate(0,' + height + ')')
                  .call(xAxis);

                g.append('g')
                  .attr('class', 'y axis')
                  .call(yAxis)
                .append("text")
                  .attr("transform", "rotate(90)")
                  .attr("y", 6)
                  .attr("dy", "-4em")
                  .style("text-anchor", "end")
                  .text(scope.type.legend);

                var totalLength = path.node().getTotalLength();

                path
                .attr("stroke-dasharray", totalLength + " " + totalLength)
                .attr("stroke-dashoffset", totalLength)
                .transition()
                  .duration(1000)
                  .ease(d3.easeLinear)
                  .attr("stroke-dashoffset", 0);

              };
              scope.render(scope.data);

              function convertDateToUTC(date) {
                return new Date(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate(), date.getUTCHours(), date.getUTCMinutes(), date.getUTCSeconds());
              }

            });

          }
    };

});
