import os
import shutil
import argparse
import codecs


ALT_SEPARATOR = '$'


def transform(src, dst, log, extensions):
    existed_files = list()
    if log is not None and os.path.exists(log):
        for line in codecs.open(log, 'r', 'utf8'):
            line = line.strip()
            existed_files.append(line)
    writer = codecs.open(log, 'a', 'utf8')
    for root, dirs, files in os.walk(src):
        for f in files:
            filename, extension = os.path.splitext(f)
            if extensions == 'all' or extension in extensions:
                src_path = os.path.abspath(os.path.join(root, f))
                prefix = os.path.abspath(src)
                file_name = src_path[len(prefix)+1:]
                dst_path = dst + os.sep + file_name.replace(os.sep, ALT_SEPARATOR)
                if file_name not in existed_files:
                    print 'Source: ', src_path
                    print 'Destination: ', dst_path
                    shutil.copyfile(src_path, dst_path)
                    writer.write(file_name + '\n')
    writer.close()


def mkdir_safe(path):
    dirs = list()
    dirs.append(path)
    while path != os.sep:
        path = os.path.dirname(path)
        dirs.append(path)
    dirs = dirs[::-1]
    for d in dirs:
        if not os.path.exists(d):
            os.mkdir(d)


def convert(src, dst):
    for root, dirs, files in os.walk(src):
        for f in files:
            src_path = os.path.join(root, f)
            file_path = f.replace(ALT_SEPARATOR, os.sep)
            dst_path = dst + os.sep + file_path
            dir_path = os.path.dirname(dst_path)
            if not os.path.exists(dir_path):
                print 'Path: ', dir_path
                mkdir_safe(dir_path)
            if not os.path.exists(dst_path):
                shutil.copyfile(src_path, dst_path)


def main():
    parser = argparse.ArgumentParser(description='Move Data')
    parser.add_argument('-s', '--src', required=True, help='Source folder')
    parser.add_argument('-d', '--dst', required=True, help='Destination folder')
    parser.add_argument('-m', '--mode', default='transform', help='Mode: transform/convert')
    parser.add_argument('-e', '--ext', default='all', nargs='+', help='File extension')
    parser.add_argument('-l', '--list', default=None, help='list')

    args = parser.parse_args()

    if args.mode == 'transform':
        transform(args.src, args.dst, args.list, args.ext)
    elif args.mode == 'convert':
        convert(args.src, args.dst)
    else:
        print 'Program only supports 2 modes: transform/convert'


if __name__ == '__main__':
    main()
