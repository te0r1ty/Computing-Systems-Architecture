import subprocess
import os


def run_asm_file(file_path, input_data):
    extra_spaces = 66
    try:
        for input in input_data:
            result = subprocess.run(["java", "-jar", "RARS.jar", file_path], input=input, text=True,
                                    capture_output=True)
            print("Входные данные от пользователя:\n" + input)
            print(result.stdout[extra_spaces:])
    except subprocess.CalledProcessError as e:
        print("Произошла ошибка:", e)


def main():
    asm_file_path = "main.asm"

    test_data = [
        "0\n",
        "65\n",
        "3\n",
        "1\n",
        "2\n",
        "10\n",
    ]

    if not os.path.exists("RARS.jar"):
        print("Ошибка: Файл rars1_6.jar не найден в текущем каталоге.")
        return

    run_asm_file(asm_file_path, test_data)


if __name__ == "__main__":
    main()
