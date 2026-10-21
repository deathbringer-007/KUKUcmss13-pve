/**
 * @file
 * @copyright 2022 raffclar
 * @license MIT
 */
import { Box } from './Box';
import { Button } from './Button';

type DialogProps = {
  readonly title: any;
  readonly onClose: () => void;
  readonly children: any;
  readonly width?: string;
  readonly height?: string;
};

export const Dialog = (props: DialogProps) => {
  const { title, onClose, children, width, height } = props;
  return (
    <div className="Dialog">
      <Box className="Dialog__content" width={width || '370px'} height={height}>
        <div className="Dialog__header">
          <div className="Dialog__title">{title}</div>
          <Box mr={2}>
            <Button
              mr="-3px"
              width="26px"
              lineHeight="22px"
              textAlign="center"
              color="transparent"
              icon="window-close-o"
              tooltip="关闭"
              tooltipPosition="bottom-start"
              onClick={onClose}
            />
          </Box>
        </div>
        {children}
      </Box>
    </div>
  );
};

type DialogButtonProps = {
  readonly onClick: () => void;
  readonly children: any;
};

const DialogButton = (props: DialogButtonProps) => {
  const { onClick, children } = props;
  return (
    <Button
      onClick={onClick}
      className="Dialog__button"
      verticalAlignContent="middle"
    >
      {children}
    </Button>
  );
};

Dialog.Button = DialogButton;

type UnsavedChangesDialogProps = {
  readonly documentName: string;
  readonly onSave: () => void;
  readonly onDiscard: () => void;
  readonly onClose: () => void;
};

export const UnsavedChangesDialog = (props: UnsavedChangesDialogProps) => {
  const { documentName, onSave, onDiscard, onClose } = props;
  return (
    <Dialog title="记事本" onClose={onClose}>
      <div className="Dialog__body">是否保存对{documentName}的修改？</div>
      <div className="Dialog__footer">
        <DialogButton onClick={onSave}>保存</DialogButton>
        <DialogButton onClick={onDiscard}>不保存</DialogButton>
        <DialogButton onClick={onClose}>取消</DialogButton>
      </div>
    </Dialog>
  );
};
