defmodule SubtitleTimeShifter do
    use Timex

    @shift_in_seconds -7

    @doc """
        ## Sample block:
        1
        00:00:42,491 --> 00:00:45,507
        Master, where did this blizzard come from?

    """
    def do_time_shift do
        input_file_name = "SorcererAndTheWhiteSnake_Input.info.srt"
        output_file_name = "SorcererAndTheWhiteSnake_Output.info.srt"

        case File.read input_file_name do
            {:ok, input_ile_contents} ->
                blocks = String.split(input_ile_contents, ~r/\r\n\r\n/, trim: true)

                {:ok, final_subtitle_file} = File.open(output_file_name, [:write, :utf8, :append])
                shift_each_block(blocks, final_subtitle_file)

                File.close final_subtitle_file
            {:error, :enoent} ->
                IO.puts "Can't find input subtitle file: #{input_file_name}"
             _ ->
                # defensive programming! Maybe we don't have the permission to read the file.
                IO.puts "An unknown error occurred in reading the subtitle input file"
        end
    end

    defp shift_each_block([], _), do: IO.puts "\nProcessing done!"
    defp shift_each_block([first_block | remaining_blocks], final_subtitle_file) do
        [block_number, block_time | block_text_list] = String.split(first_block, ~r/\r\n/, trim: true)
        IO.puts "\n------\nblockNumber: #{block_number}, blockTime: #{block_time}"

        [begin_time, end_time | _] = String.split(block_time, ~r/ --> /)
        {new_begin_time, new_end_time} = {transform_time(begin_time), transform_time(end_time)}
        new_block_time = "#{new_begin_time} --> #{new_end_time}"

        IO.binwrite final_subtitle_file, "#{block_number}\r\n"
        IO.binwrite final_subtitle_file, "#{new_block_time}\r\n"
        IO.binwrite final_subtitle_file, "#{Enum.join(block_text_list, " ")} \r\n"
        IO.binwrite final_subtitle_file, "\r\n"

        shift_each_block(remaining_blocks, final_subtitle_file)
    end

    @spec transform_time(String.t()) :: String.t()
    defp transform_time(a_block_time) do
        IO.puts "A block time: #{a_block_time}"
        [part1, part2 | _] = String.split(a_block_time, ~r/,/)
        IO.puts "Time Part1: #{part1} , Time part2: #{part2}"

        case Timex.parse(part1, "%H:%M:%S", :strftime) do
             {:ok, part1_date} ->
                 newpart1_date_time = Timex.shift(part1_date, seconds: @shift_in_seconds)
                 [_, newpart1_time | _] = String.split("#{newpart1_date_time}", ~r/ /, trim: true)

                 "#{newpart1_time},#{part2}"
            {:error, reason} ->
                IO.puts "Error in transforming block: #{reason}"
            _ ->
                IO.puts "Blast! Error in transforming block. Don't know what happened!"
        end
    end
end
