import json

def split_json(input_file, output_prefix, num_files):
    with open(input_file, 'r') as file:
        data = json.load(file)

    total_entries = len(data)
    values = list(data.values())

    chunk_size = total_entries // num_files

    for i in range(num_files):
        start_index = i * chunk_size
        end_index = (i + 1) * chunk_size
        chunk_data = values[start_index:end_index]

        output_file = f"{output_prefix}_{i + 1}.json"
        with open(output_file, 'w') as output:
            json.dump(chunk_data, output, indent=2)

        print("file ", str(i + 1), " uploaded")

    if total_entries % num_files != 0:
        start_index = num_files * chunk_size
        chunk_data = values[start_index:]

        output_file = f"{output_prefix}_{num_files + 1}.json"
        with open(output_file, 'w') as output:
            json.dump(chunk_data, output, indent=2)

        print("last file uploaded")