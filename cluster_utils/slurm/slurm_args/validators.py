from ..job_templates import templates


def job_template(arg: str) -> str:
    if arg in templates:
        return arg
    else:
        raise Exception(f"{arg} is not a valid job-template")