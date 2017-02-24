import os
import shutil
import argparse


ALT_SEPARATOR = '$'


def transform(src, dst, log):
    for root, dirs, files in os.walk(src):
        for f in files:
            src_path = os.path.abspath(os.path.join(root, f))
            prefix = os.path.abspath(src)
            file_name = src_path[len(prefix)+1:]
            dst_path = dst + os.sep + file_name.replace(os.sep, ALT_SEPARATOR)
            print 'Source: ', src_path
            print 'Destination: ', dst_path
            shutil.copyfile(src_path, dst_path)


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


def convert(src, dst, log):
    for root, dirs, files in os.walk(src):
        for f in files:
            src_path = os.path.join(root, f)
            file_path = f.replace(ALT_SEPARATOR, os.sep)
            dst_path = dst + os.sep + file_path
            dir_path = os.path.dirname(dst_path)
            if not os.path.exists(dir_path):
                print 'Path: ', dir_path
                mkdir_safe(dir_path)
            shutil.copyfile(src_path, dst_path)


def main():
    parser = argparse.ArgumentParser(description='Move Data')
    parser.add_argument('-s', '--src', required=True, help='Source folder')
    parser.add_argument('-d', '--dst', required=True, help='Destination folder')
    parser.add_argument('-m', '--mode', default='transform', help='Mode: transform/convert')
    parser.add_argument('-e', '--ext', default='all', help='File extension')
    parser.add_argument('-l', '--list', default=None, help='list')

    args = parser.parse_args()
    src = '/home/khoaipx/chatbot_log'
    dst = '/home/khoaipx/proj'
    mode = ''
    # transform('/home/khoaipx/chatbot_log', '/home/khoaipx/proj/test', None)
    # convert('/home/khoaipx/proj/test', '/home/khoaipx/proj/test2', None)


if __name__ == '__main__':
    main()
