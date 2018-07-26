#! /usr/bin/env python
"""
What this will do

Based on the Python script template at
https://github.com/BrianGallew/script_templates/blob/master/template.py
"""

import logging
import logging.handlers
import argparse
LOGGER = logging.getLogger(__name__)
OPTION_GROUP = argparse.Namespace()


def setup_logging():
    """Sets up logging in a syslog format by log level
    :param OPTION_GROUP: options as returned by the OptionParser
    """
    stderr_log_format = "%(levelname) -8s %(asctime)s %(funcName)s line:%(lineno)d: %(message)s"
    file_log_format = "%(asctime)s - %(levelname)s - %(message)s"
    syslog_format = "%(processName)s[%(process)d] - %(message)s"
    LOGGER.setLevel(level=OPTION_GROUP.loglevel)

    handlers = []
    if OPTION_GROUP.syslog:
        handlers.append(
            logging.handlers.SysLogHandler(facility=OPTION_GROUP.syslog, address='/dev/log'))
        handlers[-1].setFormatter(logging.Formatter(syslog_format))
        # Use standard format here because timestamp and level will be added by
        # syslogd.
    if OPTION_GROUP.logfile:
        handlers.append(logging.FileHandler(OPTION_GROUP.logfile))
        handlers[0].setFormatter(logging.Formatter(file_log_format))
    if not handlers:
        handlers.append(logging.StreamHandler())
        handlers[0].setFormatter(logging.Formatter(stderr_log_format))
    # Remove all the old handler(s)
    for handler in logging.root.handlers:
        logging.root.removeHandler(handler)
    # Add our new handler(s) back in
    for handler in handlers:
        LOGGER.root.addHandler(handler)
    return


def main():
    """Primary entry point."""
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    # Standard logging options.
    parser.add_argument("-v", "--verbose", action='store_const',
                        const=logging.INFO, dest='loglevel',
                        default=logging.WARNING, help="Verbose output")
    parser.add_argument("-d", "--debug", action='store_const',
                        const=logging.DEBUG, dest='loglevel',
                        default=logging.WARNING, help="Debugging output")
    parser.add_argument("--syslog", metavar="FACILITY",
                        help="Send log messages to the syslog")
    parser.add_argument("--logfile", metavar="FILENAME",
                        help="Send log messages to a file")
    # script-specific options here

    parser.parse_args(namespace=OPTION_GROUP)
    setup_logging()

    # Your code here.

    return


if __name__ == '__main__':
    main()
