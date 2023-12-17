import subprocess
import os


def run_asm_file(file_path, input_data):
    extra_spaces = 66
    try:
        for input in input_data:
            result = subprocess.run(["java", "-jar", "rars1_6.jar", file_path], input=input, text=True,
                                    capture_output=True)
            print("Входные данные от пользователя:\n" + input)
            print(result.stdout[extra_spaces:])
    except subprocess.CalledProcessError as e:
        print("Произошла ошибка:", e)


def main():
    asm_file_path = "ihw1.asm"

    test_data = [
        "-21\n",
        "0\n",
        "65\n",
        "3\n2\n6\n4\n2\n",
        "1\n2\n2",
        "1\n2\n3",
        "10\n1\n2\n3\n4\n-5\n6\n7\n8\n9\n10\n5",
        "10\n1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11",
        "8\n1\n-2\n3\n-4\n5\n6\n7\n-8\n2",
        "3\n2\n6\n4\n1",
    ]

    if not os.path.exists("rars1_6.jar"):
        print("Ошибка: Файл rars1_6.jar не найден в текущем каталоге.")
        return

    run_asm_file(asm_file_path, test_data)


if __name__ == "__main__":
    main()
