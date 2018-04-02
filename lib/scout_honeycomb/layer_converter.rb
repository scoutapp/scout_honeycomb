module ScoutHoneycomb
  class LayerConverter < ScoutApm::LayerConverters::ConverterBase
    def register_hooks(walker)
        super

        @metrics = {}

        return unless scope_layer

        walker.on do |layer|
          next if skip_layer?(layer)

          meta_options = if layer == scope_layer # We don't scope the controller under itself
                          {}
                        else
                          {:scope => scope_layer.legacy_metric_name}
                        end

          # we don't need to use the full metric name for scoped metrics as we only display metrics aggregrated
          # by type.
          metric_name = meta_options.has_key?(:scope) ? layer.type : layer.legacy_metric_name

          meta = ScoutApm::MetricMeta.new(metric_name, meta_options)
          @metrics[meta] ||= ScoutApm::MetricStats.new( meta_options.has_key?(:scope) )

          stat = @metrics[meta]
          stat.update!(layer.total_call_time, layer.total_exclusive_time)
        end
      end

      def event
        build_event
          .add(metric_fields)
          .add(context_fields)
          .add_field(:duration, root_layer.total_call_time)
          .add_field(:uri, request.annotations[:uri])
          .add_field(:name, root_layer.name)
          .add_field(:git_sha, context.environment.git_revision.sha)
          .add_field(:hostname, context.environment.hostname)
      end

      def build_event
        ScoutHoneycomb.honeycomb_client.event
      end

      def metric_fields
        @metrics.map do |meta,metric|
          [meta.type,metric.total_exclusive_time]
        end.to_h
      end

      def context_fields
        request.context.to_hash.map do |name,value|
          [name, value]
        end.to_h
      end

      def record!
        puts "honeycomb client!!! #{ScoutHoneycomb.honeycomb_client}"
        puts "honeycomb record! #{@metrics.inspect}"
        puts "honeycomb event: #{event.inspect}"
        ScoutHoneycomb.honeycomb_client.send_event(event)
      end
  end
end